# System Architecture

[<- Back](../README.md)

## Overview

The Frontend is a JAMstack application built with React. The application is
stored in an AWS S3 bucket and served via AWS CloudFront.

    Route 53 (DNS)
        |
        |
        |
    CloudFront (CDN)
        |
        |
        |
    S3 (Static Website)

The Backend is a serverless event-driven system. The whole system can be
broken down into three parts.

### Ingestion of Event Data

First is the ingestion of event data. Route53 is used to route requests to
the API Gateway publishing events to Kinesis. Kinesis then writes the events
to S3 for archival and data analysis.

    Route 53 (DNS)
        |
        |
        |
    API Gateway (REST API)
        |
        |
        |
    Kinesis (Data Streams)
        |
        |
        |
    S3 (Data Lake)

### Processing of Event Data

Second is the processing of event data. Kinesis triggers Lambda functions that
process the events and write the results to DynamoDB. Event Bridge triggers
Lambda functions on a schedule to process time-based events.

    Kinesis (Data Streams)
        |
        |
        |
    Lambda (Functions) --- Event Bridge (Time Triggers)
        |
        |
        |
    DynamoDB (Database)

### Serving of System State

Third is the serving of system state. Route53 is used to route requests to
the API Gateway serving the frontend application. The API Gateway queries
DynamoDB and returns the results to the frontend.

    Route 53 (DNS)
        |
        |
        |
    API Gateway (REST API)
        |
        |
        |
    DynamoDB (Database)

The complete toolchain looks like this:

    OpenAPI (API Spec)
  `docs/api/openapi.yaml` - Define the GET endpoints for the API Gateway.
        |
        |
        |
    DynamoDB Terraform
  `backend/terraform/dynamodb.tf` - Define the DynamoDB tables (pkey only).
        |
        |
        |
    DynamoDB Seed Data
  `backend/dynamodb/seed.json` - Seed the DynamoDB tables with data.

## Other Services

- [AWS IAM](https://aws.amazon.com/iam)
- [AWS Cognito](https://aws.amazon.com/cognito)
- [AWS CloudWatch](https://aws.amazon.com/cloudwatch)
