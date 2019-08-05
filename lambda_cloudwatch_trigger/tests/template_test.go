package tests

import (
	"encoding/json"
	"github.com/aws/aws-sdk-go/service/lambda"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
)

type Response struct {
	Response string `json:"response"`
}

type Test struct {
	Value string `json:"value"`
}

func TestTemplate(t *testing.T){
	options := &terraform.Options{
		TerraformDir:             "../examples/basic",
		Vars: map[string]interface{}{
			"prefix" : strings.ToLower(random.UniqueId()),
		},

	}
	defer terraform.Destroy(t, options)
	terraform.InitAndApply(t, options)

	region := terraform.Output(t, options, "region" )
	lambdaName := terraform.Output(t, options, "lambda_function_name")

	//Test the basic lambda function
	invokeLambda(t, region, lambdaName)

}


func invokeLambda(t *testing.T, region string, lambdaName string) {
	sess, err := aws.NewAuthenticatedSessionFromDefaultCredentials(region)

	if err != nil {
		t.Fatalf("SessionCreate err: %v\n", err)
	}

	lambdaSvc := lambda.New(sess)
	randomValue := random.UniqueId()
	testPayload := Test{
		Value: randomValue,
	}
	testJson, err := json.Marshal(&testPayload)
	if err != nil {
		t.Errorf("Failed to parse input payload: %v\n", err)
	}

	lambdaInput := &lambda.InvokeInput{
		FunctionName: &lambdaName,
		Payload: testJson,
	}

	output, err := lambdaSvc.Invoke(lambdaInput)
	if err != nil {
		t.Fatalf("Invoke Lambda err: %v\n", err)
	}

	response := Response{}

	err = json.Unmarshal(output.Payload, &response)

	if err != nil{
		t.Fatalf("Failed to parse output payload: %v\n", err)
	}
	if randomValue != response.Response{
		t.Errorf("Value does not match input:%s output:%s", randomValue, response.Response)
	}



}