// https://nextjs.org/docs/app/api-reference/next-config-js

/** @type {import('next').NextConfig} */
const nextConfig = {
  // Next.js has built-in support for internationalized (i18n) routing since
  // v10.0.0. You can provide a list of locales, the default locale, and
  // domain-specific locales and Next.js will automatically handle the routing.
  //
  // There are two locale strategies: Sub-path Routing and Domain Routing.
  // Sub-path Routing puts the locale in the url path.
  i18n: {
    // These are all the locales you want to support in your application.
    // With the below configuration en-US and es will be available to be
    // routed to, and en-US is the default locale. If you have a pages/blog.js
    // the following urls would be available:
    //
    //   /blog
    //   /es/blog
    //
    locales: ['en-US', 'es'],
    // This is the default locale you want to be used when visiting
    // a non-locale prefixed path e.g. `/hello`
    defaultLocale: 'en-US',
  },

  // React's Strict Mode is a development mode only feature for highlighting
  // potential problems in an application. It helps to identify unsafe
  // lifecycles, legacy API usage, and a number of other features.
  // Default: false
  reactStrictMode: true,

  // Next.js will add the x-powered-by header.
  // Default: true
  poweredByHeader: false,
}

module.exports = nextConfig
