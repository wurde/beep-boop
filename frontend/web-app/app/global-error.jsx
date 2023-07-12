'use client'

import React from 'react'
import Link from 'next/link'

import RootLayout from './layout'

function GlobalError({ statusCode }) {
  return (
    <RootLayout>
      <div>
        <h1>Oops, something went wrong...</h1>
        <p>
          {statusCode
            ? `An error ${statusCode} occurred on server`
            : 'An error occurred on client'}
        </p>
        <Link href="/">Go back home</Link>
      </div>
    </RootLayout>
  )
}

GlobalError.getInitialProps = ({ res, err }) => {
  // eslint-disable-next-line no-nested-ternary
  const statusCode = res ? res.statusCode : err ? err.statusCode : 404
  return { statusCode }
}

export default GlobalError
