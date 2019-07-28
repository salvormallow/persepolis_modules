package tests

import (
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
)

func TestTemplate(t *testing.T){
	options := &terraform.Options{
		TerraformDir:             "../",
		Vars: map[string]interface{}{
			"prefix" : strings.ToLower(random.UniqueId()),
		},
	}
	terraform.InitAndApply(t, options)

	region := "use-east-1"
	bucketName := terraform.Output(t, options, "bucketName")
	defer terraform.Destroy(t, options)
	defer aws.EmptyS3Bucket(t, region, bucketName)


	bucketSize, err := getS3Size(t, region, bucketName)
	if err != nil{
		t.Fatalf("Getting bucketSize failed %v\n", err)
	}
	if bucketSize ==0 {
		t.Errorf("Bucket was empty after lambda was created")
	}
}


func getS3Size(t *testing.T, region string, bucketID string) (int64, error) {
	s3Client := aws.NewS3Client(t, region)
	var bucketSize int64
	err := s3Client.ListObjectsV2Pages(&s3.ListObjectsV2Input{Bucket: &bucketID}, func(page *s3.ListObjectsV2Output, last bool) (shouldContinue bool) {
		for _, obj := range page.Contents {
			bucketSize = bucketSize + *obj.Size
		}
		return true
	})
	if err != nil {
		return 0, err
	}

	return bucketSize, nil
}
