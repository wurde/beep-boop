/* eslint-disable no-restricted-syntax */

const fs = require('fs')
const path = require('path')
const { exec } = require('child_process')

// eslint-disable-next-line import/no-extraneous-dependencies
const dotenv = require('dotenv')

// Resolve the path to the .env.local file relative to this script
const envFilePath = path.resolve(__dirname, '../../frontend/web-app/.env.local')

if (!fs.existsSync(envFilePath)) {
  fs.writeFileSync(envFilePath, '')
}

// Run terraform output command to get JSON output
exec('cd terraform && terraform output -json', (err, stdout) => {
  if (err) {
    // eslint-disable-next-line no-console
    console.error(`exec error: ${err}`)
    return
  }

  // Parse the JSON output
  const output = JSON.parse(stdout)

  // Read env file and parse it
  const envConfig = dotenv.parse(fs.readFileSync(envFilePath, 'utf8'))

  // Update env keys with Terraform output values
  for (const key in output) {
    if (Object.prototype.hasOwnProperty.call(output, key)) {
      const element = output[key]
      const reactKey = `NEXT_PUBLIC_${key.toUpperCase()}`
      if (Object.prototype.hasOwnProperty.call(envConfig, reactKey)) {
        envConfig[reactKey] = element.value
      }
    }
  }

  // Prepare updated env content
  let envContent = ''
  for (const key in envConfig) {
    if (Object.prototype.hasOwnProperty.call(envConfig, key)) {
      envContent += `${key}=${envConfig[key]}\n`
    }
  }

  // Write updated content to env file
  fs.writeFileSync(envFilePath, envContent)
})
