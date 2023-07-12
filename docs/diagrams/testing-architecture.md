# Testing Architecture

[<- Back](../README.md)

    "Write tests. Not too many. Mostly integration."
    - Kent C. Dodds

A strategic decision around testing is to focus efforts solely on
feature testing (also known as end-to-end or integration testing).
This approach is based on the premise that the user interface is the
most important part of the application and should be tested as a
whole. This is in contrast to unit testing, which focuses on testing
individual units of code in isolation. The main advantage of feature
testing is that it allows you to test the application from the user's
perspective, which is the most important perspective to consider when
building a user interface.

## Feature Testing

    BeforeEach Hook: Refresh Test Data via Cypress Task

      cy.task() provides an escape hatch for running arbitrary Node code,
      so you can take actions necessary for your tests outside of the scope
      of Cypress. This is great for:

    ^
    |
    |

    Cloud Events: Seed File - Setup of the Test Data

      A seed file, in the context of testing, is a file that sets up the
      initial state of your application. For our event-driven architecture
      we need to reset the event stream data and database data, so that it
      can be tested under consistent conditions.

      In the `seed.json` file we can define our test data.

      File: `frontend/web-app/cypress/fixtures/event-stream-seed.json`

      ```json
      TODO
      ```

    ^
    |
    |

    BeforeAll Hook: Start the Next.js App and Local Stack Test Environment

      LocalStack functions as a local “mini-cloud” operating system that runs
      inside a Docker container. LocalStack has multiple components, which
      include process management, file system abstraction, event processing,
      schedulers, and more. Running inside a Docker container, LocalStack
      exposes external network ports for integrations, SDKs, or CLI interfaces
      to connect to LocalStack APIs.
      https://docs.localstack.cloud/references/docker-images
      https://docs.localstack.cloud/references/configuration

      ```bash
      # Print the environment variables of the running container
      docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' localstack_main

      # Shows running containers
      docker ps
      # Shows all containers, including those that are stopped.
      docker ps -a

      # Confirm running Local Stack instance
      localstack status

      # Print Local Stack configuration
      localstack config show
      ```

      There's an npm package called `start-server-and-test` that is used to
      start the Next.js server and then run the tests once the server is ready.
      https://npmjs.com/package/start-server-and-test

      ```bash
      cd test/
      npm install --save-dev start-server-and-test
      ```

      This command is meant to be used with NPM script commands. If you have a
      "start server", and "test" script names for example, you can start the
      server, wait for a url to respond, then run tests. When the test process
      exits, the server is shut down.

      ```json
      "scripts": {
        "start:backend": "(cd ../backend && npm run start)",
        "start:frontend": "(cd ../frontend/web-app && npm run start)",
        "cy:open": "cypress open --e2e",
        "cy:run": "cypress run --e2e",
        "test": "start-server-and-test start:backend http://localhost:4566 start:frontend http://localhost:3000 cy:open",
        "ci:test": "start-server-and-test start:backend http://localhost:4566 start:frontend http://localhost:3000 cy:run"
      }
      ```

      Common Local Stack commands:

      ```bash
      # Check status of Local Stack
      localstack status

      # Stop Local Stack
      localstack stop
      ```

    ^
    |
    |

    Cucumber with Cypress: Step Definitions

      Cucumber is a popular BDD testing framework that works with Gherkin. It
      allows you to automate the execution of Gherkin scenarios by mapping
      each step in the Gherkin file to corresponding step definitions in code.

      Cypress is an end-to-end testing framework that allows you to write tests
      that simulate user interactions within a web application. Cypress provides
      a powerful API for interacting with web elements, making assertions,
      and observing the application's behavior in real-time.
      https://www.cypress.io
      https://docs.cypress.io/guides/guides/command-line
      https://docs.cypress.io/guides/references/configuration

      Cypress doesn't support Gherkin syntax out of the box. However, it's
      possible to configure Cypress to use Gherkin syntax by using a plugin
      called `cypress-cucumber-preprocessor`. This plugin enables you to write
      your Cypress tests using Gherkin syntax and have them run as regular
      Cypress tests. When properly installed and configured, the package
      pre-processes your .feature files before they reach Webpack. It converts
      the Gherkin syntax into JavaScript that can be understood by Cypress, so
      by the time Webpack gets involved, it's just dealing with regular
      JavaScript files.
      https://github.com/badeball/cypress-cucumber-preprocessor
      https://github.com/badeball/cypress-cucumber-preprocessor/blob/master/docs/quick-start.md
      https://github.com/badeball/cypress-cucumber-preprocessor/blob/master/docs/readme.md

      See an example step definition file below. Note how the step definitions
      will match the Gherkin steps in the feature files. It's the Gherkin steps
      that are the source of truth for the test. They are used as regex patterns
      to match the step definitions.

      ```javascript
      // tests/cypress/e2e/domain1/Feature1.js
      const { When, Then } = require("@badeball/cypress-cucumber-preprocessor");

      When("I visit duckduckgo.com", () => {
        cy.visit("https://duckduckgo.com/");
      });

      Then("I should see a search bar", () => {
        cy.get("input").should(
          "have.attr",
          "placeholder",
          "Search the web without being tracked"
        );

        assert.deepEqual({}, {});
      });
      ```

      Note the following step defintion file can be a placeholder:

      ```javascript
      import {
        Given,
        When,
        Then
      } from "@badeball/cypress-cucumber-preprocessor";

      /**
       * Scenario: TODO
       */

      Given('TODO', () => {
        return "pending"
      });

      When('TODO', () => {
        return "pending"
      });

      Then('TODO', () => {
        return "pending"
      });
      ```

    ^
    |
    |

    Gherkin: Feature Files

      Gherkin is a structured natural language syntax used for specifying
      the behavior of software systems in a human-readable and understandable
      format. It is primarily associated with behavior-driven development
      (BDD), a software development approach that aims to align business
      stakeholders, developers, and testers by describing system behavior in
      a common language.

      The Gherkin language is officially maintained by Cucumber, an 
      open-source software testing tool that supports BDD​. As of the latest 
      check on GitHub (April 7, 2023), the current long-term support version 
      of Gherkin is v26.2.0​. https://github.com/cucumber/gherkin

      tests
      ├── cypress
      |   ├── e2e
      │   |   ├── domain1
      │   │   |   ├── Feature1.feature
      │   │   |   └── Feature1.js
      │   |   └── domain2
      │   │       ├── Feature1.feature
      │   │       ├── Feature1.js
      │   │       ├── Feature2.feature
      │   │       └── Feature2.js
      ├── fixtures
      │   ├── database-seed.json
      |   └── event-stream-seed.json
      └── support
          ├── step_definitions
          |   └── reset-test-data.js
          ├── commands.js
          └── e2e.js

      `e2e`: This directory contains the Gherkin feature files and step 
      definitions, organized by domain. Each domain has its own folder 
      (domain1, domain2, etc.).

      `fixtures`: This directory contains the seed file that sets up the 
      initial state of the event stream with Cloud Events.

      An example feature file:

      ```gherkin
      // tests/cypress/e2e/domain1/Feature1.feature
      Feature: duckduckgo.com

        As a user
        I want to visit duckduckgo.com
        So that I can search the web

        Scenario: visiting the frontpage
          When I visit duckduckgo.com
          Then I should see a search bar
      ```
