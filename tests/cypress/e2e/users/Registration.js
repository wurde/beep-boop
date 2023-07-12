import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor'

/**
 * Common steps
 */

Given('I am on the registration page', () => {
  cy.visit('/register')
})

When('I click on the "Register" button', () => {
  cy.get('button#register').click()
})

/**
 * Scenario: Successful registration
 */

When('I enter a valid email and password', () => {
  cy.get('input#email').type('test@example.com')
  cy.get('input#password').type('password123')
})

Then('I should see a confirmation message', () => {
  cy.contains('Registration successful!')
})

/**
 * Scenario: Registration with already used email
 */

Given('there is already a user registered with "usedemail@example.com"', () => {
  cy.fixture('database-seed').then(data => {
    const emailExists = data.some(
      item => item.Item.email === 'usedemail@example.com',
    )

    expect(
      emailExists,
      `The item with email usedemail@example.com does not exist in the fixture file.`,
    ).to.be.true
  })
})

When('I try to register with "usedemail@example.com"', () => {
  cy.get('input#email').type('usedemail@example.com')
  cy.get('input#password').type('password123')
})

Then('I should see an error message that the email is already used', () => {
  cy.contains('Email is already used!')
})
