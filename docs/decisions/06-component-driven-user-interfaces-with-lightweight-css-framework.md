# ADR 06: Component-Driven User Interfaces with Lightweight CSS Framework

[<- Back](../README.md)

## Context

We want to make the UI development more modular and manageable while keeping
the website lightweight.

## Decision

We will build component-driven user interfaces with a lightweight CSS framework.

A component-driven user interface is a development paradigm that breaks down
the complex user interface (UI) into smaller, reusable elements called
components. Each component encapsulates a certain functionality or a set of
functionalities, complete with its own UI representation and underlying logic.
This approach boosts modularity and reusability, allowing developers to
assemble various UIs by recombining these components. Internally, a component
maintains its own state, which represents the data it is currently working with.
Moreover, CDUI promotes separation of concerns, where each component is
responsible for a specific part of the UI and its corresponding functionality,
which can result in cleaner and more maintainable code. This paradigm has been
popularized by libraries and frameworks such as React, Vue.js, and Angular.
Component-driven development is also crucial for implementing complex patterns
like Model-View-ViewModel (MVVM) and Model-View-Controller (MVC), providing a
systematic way to organize code and manage interaction between system elements.

A CSS Framework is a pre-prepared library that is meant to allow for easier,
more standards-compliant web design using the Cascading Style Sheets language.
Most of these frameworks contain at least a grid system, typography styles, and
often more complex components like button styles, form elements, modals, and
various other reusable components. CSS frameworks are designed to be included
when starting to build a website to jump-start development, providing a
responsive grid system and foundational styles, allowing developers to focus on
creating the unique aspects of their website rather than the foundational CSS.
Some widely used CSS frameworks include Bootstrap, Foundation, Bulma, and
Tailwind CSS. They aim to solve common design problems, improve project
maintainability, and increase productivity in web development by providing a
consistent foundation for building web interfaces.

The sub-decisions associated with this ADR include:

- We will use TailwindCSS for our CSS framework.
- We will use Bit for our component library.

## Consequences

- Easier to maintain and reuse components.
- Might take time to set up the component library.
- Developers need to learn and adapt to the chosen CSS framework.
