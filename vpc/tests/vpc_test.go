package tests

import (
	//"encoding/json"
	"fmt"
 	//"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	//"math/rand"
	//"strconv"
	"testing"
	"time"
)

var time_now = time.Now()
var now_str = time_now.Format("1136239445")

var terraform_vars = map[string]interface{}{
    "prefix": now_str,
    "instance_type": "t2.micro",
    "key_name": "centOS",
    "block_vol_type": "gp2",
    "test_instance_name": "jenkins_test",
}

func TestTerraformApply(t *testing.T) {
	t.Parallel()
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples",
		Vars: terraform_vars,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	fmt.Println("Obtaining instance ID")
// 	instanceIP := terraform.Output(t, terraformOptions, "instance_public_ip")
// 	instanceID := terraform.Output(t, terraformOptions, "instance_id")
	fmt.Println("Waiting for 10s")
	time.Sleep(time.Second * 10)
}
