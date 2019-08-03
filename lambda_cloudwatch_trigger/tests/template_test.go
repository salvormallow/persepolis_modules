package tests

import (
	"github.com/aws/aws-sdk-go/service/lambda"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
)

func TestTemplate(t *testing.T){
	options := &terraform.Options{
		TerraformDir:             "../examples/template",
		Vars: map[string]interface{}{
			"prefix" : strings.ToLower(random.UniqueId()),
		},
	}
	defer terraform.Destroy(t, options)
	terraform.InitAndApply(t, options)

	//region := "us-east-1"




}


func invokeLambda(t *testing.T, region string, lambdaArn string) {
	sess, err := aws.NewAuthenticatedSessionFromDefaultCredentials(region)

	if err != nil {
		t.Fatalf("SessionCreate err: %v\n", err)
	}

	lambdaSvc := lambda.New(sess)
	functionName := lambdaArn

	lambdaInput := &lambda.InvokeInput{
		FunctionName: &functionName,
	}

	_, err = lambdaSvc.Invoke(lambdaInput)
	if err != nil {
		t.Fatalf("Invoke Lambda err: %v\n", err)
	}

}