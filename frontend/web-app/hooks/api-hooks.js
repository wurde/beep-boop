// // https://swr.vercel.app
// //
// // React hook for data fetching. The name “SWR” is derived from
// // stale-while-revalidate, a HTTP cache invalidation strategy popularized by
// // HTTP RFC 5861. SWR is a strategy to first return the data from cache
// // (stale), then send the fetch request (revalidate), and finally come with
// // the up-to-date data.
// import useSWR from 'swr'

// // https://npmjs.com/package/openapi-typescript-codegen
// //
// // The OpenAPI specification, formerly known as Swagger, is a specification for
// // machine-readable interface files for describing, producing, consuming, and
// // visualizing RESTful web services. You can use OpenAPI Generator to generate
// // a client SDK from an OpenAPI spec.
// import { DefaultService } from '../lib/apiClient'

// const fetcher = url => apiClient.getClientData(url)

// export function getUserByEmail(email) {
//   const { data, error } = useSWR(apiEndpoint, fetcher)

//   return {
//     data,
//     isLoading: !error && !data,
//     isError: error
//   }
// }
