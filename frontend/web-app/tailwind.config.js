const breakpoints = require('./style-tokens/breakpoints')
const colors = require('./style-tokens/colors')
const fontFamily = require('./style-tokens/font-family')
const spacing = require('./style-tokens/spacing')

/** @type {import('tailwindcss').Config} */
module.exports = {
  // Support toggling dark mode manually instead of relying on the operating
  // system preference, use the class strategy instead of the media strategy.
  darkMode: 'class',
  // Configuring the content sources.
  // https://tailwindcss.com/docs/content-configuration
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  // Customizing the default theme.
  // https://tailwindcss.com/docs/theme
  theme: {
    extend: {
      screens: breakpoints,
      colors,
      fontFamily,
      spacing,
    },
  },
  plugins: [],
}
