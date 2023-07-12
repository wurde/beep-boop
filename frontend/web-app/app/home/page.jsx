'use client'

import { useEffect, useState } from 'react'

// https://www.npmjs.com/package/@aws-amplify/ui-react
//
// Amplify UI is an open-source UI library with cloud-connected components
// that are endlessly customizable, accessible, and can integrate into any
// application.
import { withAuthenticator } from '@aws-amplify/ui-react'
import { Auth } from 'aws-amplify'
import '@aws-amplify/ui-react/styles.css'

import '../_config/amplify'

import { ApiClient, DefaultApi } from '../_config/api'

import CloudEventForm from '../../components/CloudEventForm'

function HomePage({ signOut, user }) {
  const [apiClient] = useState(new DefaultApi())
  const [equationData, setEquationData] = useState('')

  useEffect(() => {
    async function fetchData() {
      try {
        const currentUserInfo = await Auth.currentUserInfo()
        // eslint-disable-next-line no-console
        console.log('Success - Auth.currentUserInfo', currentUserInfo)

        const defaultClient = ApiClient.instance
        // The ID Token contains claims about the identity of the authenticated
        // user such as name, email, and phone_number.
        //
        // - https://docs.amplify.aws/lib/restapi/authz/q/platform/js
        defaultClient.authentications.CognitoAuthorizer.apiKey = (
          await Auth.currentSession()
        )
          .getAccessToken()
          .getJwtToken()

        const response = await new Promise((resolve, reject) => {
          apiClient.getUserById(
            '550e8400-e29b-41d4-a716-446655440000',
            (error, data, res) => {
              if (error) {
                reject(error)
              } else {
                resolve(res)
              }
            },
          )
        })
        // eslint-disable-next-line no-console
        console.log('Success - DynamoDB getUserById', JSON.stringify(response))
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error('Failed to fetch user data', error)
      }
    }
    fetchData()
  }, [])

  return (
    <div className="min-h-screen bg-gray-50 text-gray-800 flex flex-col">
      <section className="text-center px-4 py-8 tablet:px-0">
        <h1 className="mx-6 py-4 text-1xl md:text-2xl lg:text-3xl font-bold text-center text-gray-300 uppercase tracking-wide shadow-lg">
          {user.attributes.email}
        </h1>
      </section>

      <main className="flex-grow">
        <section className="text-center px-4 py-8 tablet:px-0">
          <CloudEventForm
            apiClient={apiClient}
            equationData={equationData}
            setEquationData={setEquationData}
          />

          {equationData ? (
            <div>
              <p style={{ whiteSpace: 'pre-line' }}>{equationData}</p>
            </div>
          ) : (
            <p>Loading...</p>
          )}
        </section>
      </main>

      <footer className="mt-auto p-4 text-center bg-gray-180 text-red-400">
        <button type="button" onClick={signOut}>
          Sign out
        </button>
      </footer>
    </div>
  )
}

// The withAuthenticator is a higher-order component (HoC) that wraps
// Authenticator. You'll also notice the user and signOut are provided to
// the wrapped component.
export default withAuthenticator(HomePage)
