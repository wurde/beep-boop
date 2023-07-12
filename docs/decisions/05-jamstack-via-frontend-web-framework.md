# ADR 05: JAMstack via Frontend Web Framework

[<- Back](../README.md)

## Context

We want to build fast and secure websites and apps delivered by pre-rendering
files and serving them directly from a CDN.

## Decision

We will use JAMstack via a frontend web framework.

Jamstack is a modern architecture for building web applications that offers a
highly performant, scalable, and secure framework. The acronym stands for
JavaScript, APIs, and Markup. In Jamstack, JavaScript, running entirely on the
client side, handles any dynamic programming during the request/response cycle.
APIs, reusable interfaces accessed over HTTP with JavaScript, encapsulate all
server-side operations or database actions, making the system modular and
extensible. Markup, prebuilt at build time, usually via a site generator for
content sites or a build tool for web apps, gets served directly from a CDN.
This decoupling of the front-end stack from the back-end server, along with the
pre-rendering of the site, results in highly optimized delivery and execution,
improved performance, cheaper scaling, and a greater developer experience.

The sub-decisions associated with this ADR include:

- We will use Next.js for our frontend web framework.

## Consequences

- Improved performance and security.
- Reduced complexity of managing server-side code.
- Developers need to be comfortable with the chosen frontend framework.
