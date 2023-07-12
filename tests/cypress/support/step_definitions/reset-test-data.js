import { Before } from '@badeball/cypress-cucumber-preprocessor'

Before(() => {
  cy.task('default:event-stream').then(result => {
    expect(result).to.equal('Reset the event stream')
  })

  cy.task('default:database').then(result => {
    expect(result).to.equal('Reset the database')
  })
})
