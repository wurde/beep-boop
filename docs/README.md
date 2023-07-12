# Documentation

[<- Back](../README.md)

## End-to-end Feature Development Lifecycle

These are the recommended steps to implementing a feature from start to finish.
Note all of this work should be done on a separate feature branch following
[Gitflow.](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

1. Write Gherkin user stories.

    This is all about defining the behavior of the feature from the user's
    perspective. The benefit is to ensure everyone in the team understands the
    desired functionality and that the development stays focused on meeting
    user needs.

2. Write Cypress step definitions.

    This refers to defining automated tests for your application, ensuring it
    behaves as expected. This improves overall application quality and helps
    catch issues before they reach production.

3. Write React components.

    This involves creating the visual and interactive elements of your
    feature. The benefit is that it allows you to build high-quality user
    interfaces that meet your user stories' needs.

4. Update OpenAPI specification.

    The OpenAPI Specification provides a standardized framework for describing
    RESTful APIs. The benefit here is it makes it easy for people to
    understand and use your API, and it can be used to auto-generate
    documentation, client SDKs, and more.

5. Update Terraform configuration.

    Terraform is used to manage your infrastructure as code. This step ensures
    your infrastructure is configured correctly for your new feature, which
    can lead to more reliable deployments and easier infrastructure management.

6. Write Lambda functions.

    This involves creating serverless functions that run your backend code.
    This allows for efficient scaling, reduces the need to manage servers,
    and can often result in cost savings.

7. Run tests successfully locally.

    By running tests on your local environment before pushing changes, you
    can catch and fix issues early. This leads to higher-quality code and less
    time spent on debugging later.

8. Deploy to AWS.

    This final step gets your new feature out into the world, where it can
    provide value to users. AWS's robust and scalable infrastructure can
    provide a reliable and performant environment for your feature.

## Architecture Decision Records

- [ADR00 Record architecture decisions](./decisions/00-record-architecture-decisions.md)
- [ADR01 Continuous integration and continuous delivery](./decisions/01-continuous-integration-and-continuous-delivery.md)
- [ADR02 Full managed serverless on a single cloud provider](./decisions/02-full-managed-serverless-on-a-single-cloud-provider.md)
- [ADR03 Infrastructure-as-code with policy-as-code](./decisions/03-infrastructure-as-code-with-policy-as-code.md)
- [ADR04 Test-driven development with code coverage](./decisions/04-test-driven-development-with-code-coverage.md)
- [ADR05 JAMstack via frontend web framework](./decisions/05-jamstack-via-frontend-web-framework.md)
- [ADR06 Component-driven user interfaces with lightweight CSS framework](./decisions/06-component-driven-user-interfaces-with-lightweight-css-framework.md)
- [ADR07 CQRS and event sourcing backend](./decisions/07-cqrs-and-event-sourcing-backend.md)
- [ADR08 Primary programming language](./decisions/08-primary-programming-language.md)
- [ADR09 ESlint and Prettier for Static Code Analysis](./decisions/09-eslint-prettier-static-code-analysis.md)

## Diagrams

- [System Architecture](./diagrams/system-architecture.md)
- [Testing Architecture](./diagrams/testing-architecture.md)

## API Specifications

- [API Documentation](./api/README.md)
