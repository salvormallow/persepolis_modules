package template

import (
	"context"
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(HandleRequest)
}

type Test struct {
	Value string `json:"value"`
}

func HandleRequest(ctx context.Context, event Test) (string, error) {
	return event.Value, nil
}
