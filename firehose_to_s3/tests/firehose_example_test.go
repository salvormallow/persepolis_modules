package tests

import (
	"encoding/json"
	"fmt"
	"github.com/aws/aws-sdk-go/service/firehose"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"math/rand"
	"strconv"
	"strings"
	"testing"
	"time"
)

type testRecord struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
}

func TestTerraformAnalytics(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"prefix": strings.ToLower(random.UniqueId()),
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	region := "us-east-1"
	firehoseName := terraform.Output(t, terraformOptions, "firehose_name")
	firehoseBufferInterval, _ := strconv.Atoi(terraform.Output(t, terraformOptions, "firehose_buffer_interval"))
	bucketName := terraform.Output(t, terraformOptions, "bucket_name")

	defer aws.EmptyS3Bucket(t, region, bucketName)

	//send a test message to firehose then sleep to let the message arrive in s3
	sendFirehoseMessage(t, region, firehoseName)

	//wait for message to arrive in bucket
	time.Sleep(time.Duration(firehoseBufferInterval+60) * time.Second)

	//check s3 for the message
	assertS3NotEmpty(t, region, bucketName)

}

func sendFirehoseMessage(t *testing.T, region string, firhoseName string) {
	sess, err := aws.NewAuthenticatedSessionFromDefaultCredentials(region)

	if err != nil {
		t.Fatalf("SessionCreate err: %v\n", err)
	}

	fhSvc := firehose.New(sess)

	recordInput := &firehose.PutRecordInput{}
	recordInput = recordInput.SetDeliveryStreamName(firhoseName)

	data := testRecord{
		ID:          rand.Intn(50),
		Name:        fmt.Sprintf("Name-%d", rand.Intn(50)),
		Description: fmt.Sprintf("Test-Description %d", rand.Intn(50)),
	}

	b, err := json.Marshal(data)

	if err != nil {
		t.Errorf("Failed to marshal the test object")
	}

	record := &firehose.Record{Data: b}
	recordInput.SetRecord(record)
	_, err = fhSvc.PutRecord(recordInput)
	if err != nil {
		t.Fatalf("PutRecordBatch err: %v\n", err)
	}
}

func assertS3NotEmpty(t *testing.T, region string, bucketName string) int {
	s3Client := aws.NewS3Client(t, region)
	resp, err := s3Client.ListObjectsV2(&s3.ListObjectsV2Input{Bucket: &bucketName})
	if err != nil {
		t.Fatalf("List Bucket err: %v\n", err)
	}
	if len(resp.Contents) == 0 {
		t.Errorf("List Bucket returned 0 results.")
	}
	fmt.Println(resp.Contents)
	bucketSize := 0
	for _, item := range resp.Contents {
		bucketSize = bucketSize + int(*item.Size)
	}
	return bucketSize
}