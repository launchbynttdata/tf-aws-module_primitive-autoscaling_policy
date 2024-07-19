package common

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/applicationautoscaling"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAutoscalingPolicy(t *testing.T, ctx types.TestContext) {
	appAutoscalingClient := applicationautoscaling.NewFromConfig(GetAWSConfig(t))
	policyArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "autoscaling_policy_arn")
	serviceId := terraform.Output(t, ctx.TerratestTerraformOptions(), "service_id")
	fargateArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "fargate_arn")
	fargateName := strings.Split(fargateArn, "/")[1]

	resourceId := "service/" + fargateName + "/" + serviceId
	output, err := appAutoscalingClient.DescribeScalingPolicies(context.TODO(), &applicationautoscaling.DescribeScalingPoliciesInput{
		ServiceNamespace: "ecs",
		ResourceId:       &resourceId,
	})
	if err != nil {
		t.Errorf("Unable to describe scaling policies, %v", err)
	}

	t.Run("TestOnlyOnePolicyExists", func(t *testing.T) {
		assert.Len(t, output.ScalingPolicies, 1, "Expected one scaling policy, got %d", len(output.ScalingPolicies))
	})

	scalingPolicy := output.ScalingPolicies[0]

	t.Run("TestPolicyHasCorrectArn", func(t *testing.T) {
		require.Equal(t, policyArn, *scalingPolicy.PolicyARN, "Expected resource ID to be %s, got %s", policyArn, *scalingPolicy.PolicyARN)
	})
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
