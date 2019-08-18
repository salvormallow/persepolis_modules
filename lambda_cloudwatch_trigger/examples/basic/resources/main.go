package main

import (
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(HandleRequest)
}

type Test struct {
	Value string `json:"value"`
}

type Response struct {
	Response string `json:"response"`
}

func HandleRequest(event Test) (Response, error) {
	return Response{event.Value}, nil
}
