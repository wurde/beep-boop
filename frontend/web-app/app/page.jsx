'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'

import { DefaultApi } from './_config/api'

import Game from '../components/Game'

export default function Home() {
  const [apiClient] = useState(new DefaultApi())

  useEffect(() => {
    apiClient.getUserById(
      '550e8400-e29b-41d4-a716-446655440000',
      (error, data, response) => {
        if (error) {
          // eslint-disable-next-line no-console
          console.error(error)
        } else {
          // eslint-disable-next-line no-console
          console.log('Success', JSON.stringify(response))
        }
      },
    )
  }, [])

  return (
    <div className="min-h-screen bg-gray-50 text-gray-800 flex flex-col">
      <section className="text-center px-4 py-8 tablet:px-0">
        <h1 className="text-4xl tablet:text-6xl font-bold text-gray-600 mb-4">
          Beep Boop
        </h1>
        <p className="text-xl tablet:text-2xl text-gray-400">
          A little adventure in modern web development.
        </p>
      </section>

      <main className="flex-grow">
        <section className="text-center px-4 py-8 tablet:px-0">
          <Game />
        </section>

        <section className="grid grid-cols-1 tablet:grid-cols-2 gap-4 p-4">
          <div className="p-4 bg-gray-200 text-gray-600 shadow rounded">
            <h2 className="text-lg">
              <b>
                It is not the strongest of the species that survives, nor the
                most intelligent that survives. It is the one that is the most
                adaptable to change.
              </b>{' '}
              <br />
              <span className="text-sm">- Charles Darwin</span>
            </h2>
          </div>
          <ul className="text-center underline">
            <li>
              <Link href="/home" className="text-2xl text-blue-400">
                Sign In
              </Link>
            </li>
          </ul>
        </section>
      </main>

      <footer className="mt-auto p-4 text-center bg-gray-180 text-gray-400">
        <p>Powered by caffeine and keyboard strokes.</p>
      </footer>
    </div>
  )
}
