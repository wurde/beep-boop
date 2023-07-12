import React from 'react'

import { Formik, Form, Field, ErrorMessage } from 'formik'
import { CloudEvent, HTTP } from 'cloudevents'

function CloudEventForm({ apiClient, equationData, setEquationData }) {
  const onSubmit = (values, { setSubmitting, resetForm }) => {
    // CloudEvents are a specification for describing event data in a common way.
    // They standardize the structure of event data transferred between cloud
    // systems, improving interoperability and enabling easier, more flexible
    // event-driven architectures. This allows developers to focus on
    // application logic rather than infrastructure details.
    //
    // - https://github.com/cloudevents/spec
    // - https://cloudevents.io
    // - https://www.npmjs.com/package/cloudevents
    const event = new CloudEvent({
      source: 'https://api.example.com/events',
      type: 'com.example.events.equationComposed.2023-06-29',
      data: values,
    })

    const message = HTTP.binary(event)
    // eslint-disable-next-line no-console
    console.log('CloudEvent', message)
    setEquationData(`${equationData}\n${values.equation}`)

    new Promise((resolve, reject) => {
      apiClient.logEvent(message.body, (error, data, res) => {
        if (error) {
          reject(error)
        } else {
          resolve(res)
        }
      })
    })
      .then(response => {
        // eslint-disable-next-line no-console
        console.log('Success - Kinesis logEvent', JSON.stringify(response))
      })
      .then(() => {
        resetForm()
      })
      .catch(error => {
        // eslint-disable-next-line no-console
        console.error(error)
      })
      .finally(() => setSubmitting(false))
  }

  return (
    <div className="w-full max-w-xs mx-auto">
      <Formik
        initialValues={{ equation: '' }}
        validate={values => {
          const errors = {}
          if (!values.equation) {
            errors.equation = 'Required'
          }
          return errors
        }}
        onSubmit={onSubmit}
      >
        {({ isSubmitting }) => (
          <Form className="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
            <div className="mb-4">
              <label
                className="block text-gray-700 text-sm font-bold mb-2"
                htmlFor="equation"
              >
                Equation
                <p className="text-xs text-gray-300">
                  write some simple math (e.g. 40+2)
                </p>
                <Field
                  id="equation"
                  type="text"
                  name="equation"
                  className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                />
                <ErrorMessage
                  name="equation"
                  component="div"
                  className="text-red-500 text-xs italic"
                />
              </label>
            </div>
            <div className="flex items-center">
              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
              >
                Submit
              </button>
            </div>
          </Form>
        )}
      </Formik>
    </div>
  )
}

export default CloudEventForm
