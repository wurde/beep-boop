// https://docs.cypress.io/guides/references/configuration

const { defineConfig } = require('cypress')
const createBundler = require('@bahmutov/cypress-esbuild-preprocessor')
const preprocessor = require('@badeball/cypress-cucumber-preprocessor')
// eslint-disable-next-line import/no-unresolved
const createEsbuildPlugin = require('@badeball/cypress-cucumber-preprocessor/esbuild')
const resetEventStream = require('../backend/utils/reset-event-stream')
const resetDatabase = require('../backend/utils/reset-database')
const databaseSeed = require('./cypress/fixtures/database-seed.json')
const eventStreamSeed = require('./cypress/fixtures/event-stream-seed.json')

async function setupNodeEvents(on, config) {
  // This is required for the preprocessor to be able to generate JSON reports after each run, and more,
  await preprocessor.addCucumberPreprocessorPlugin(on, config)

  on(
    'file:preprocessor',
    createBundler({
      plugins: [createEsbuildPlugin.default(config)],
    }),
  )

  on('task', {
    'default:event-stream': () => {
      resetEventStream(eventStreamSeed)
      return 'Reset the event stream'
    },
    'default:database': () => {
      resetDatabase(databaseSeed)
      return 'Reset the database'
    },
  })

  // Make sure to return the config object as it might have been modified by the plugin.
  return config
}

module.exports = defineConfig({
  // Configuration options specific to end-to-end testing.
  e2e: {
    // URL used as prefix for cy.visit() or cy.request() command's URL.
    // Default: null
    baseUrl: 'http://localhost:3000',

    // A String or Array of glob patterns of the test files to load.
    // Default: "cypress/e2e/**/*.cy.{js,jsx,ts,tsx}"
    specPattern: '**/*.feature',

    // Path to file to load before spec files load.
    // This file is compiled and bundled. (Pass false to disable)
    // Default: "cypress/support/e2e.{js,jsx,ts,tsx}"
    supportFile: 'cypress/support/e2e.js',

    setupNodeEvents,
  },

  // Whether to take a screenshot when a test fails during `cypress run`.
  screenshotOnRunFailure: false,

  // Whether to capture a video of the tests run with `cypress run`.
  video: false,
})
