# ADR 08: Primary Programming Language

[<- Back](../README.md)

## Context

We need a programming language to build our software. The choice should be
driven by the project requirements, the expertise of the team, and the
ecosystem of the language.

## Decision

We will select GoLang as our primary programming language for the project.

Go, often referred to as GoLang to disambiguate it from the board game, is a
statically typed, compiled programming language designed at Google by Robert
Griesemer, Rob Pike, and Ken Thompson. Launched in 2007 and publicly announced
in 2009, it was conceived to increase productivity in development cycles,
favoring simplicity and clarity of syntax. Go offers the efficiency of
statically typed compiled languages like C++ with the ease of syntax and
garbage collection of dynamic languages like Python. It features a strong focus
on concurrency, facilitated by Goroutines and Channels, which makes it
particularly suited for network services and distributed systems. It supports
modular program construction through packages, has a robust standard library,
and uses a unique model for managing dependencies, originally through the
GOPATH, and more recently through Go modules. Go's design also emphasizes
orthogonality, ensuring that the language features are both composable and
independent from one another.

## Consequences

- Direct impact on the performance, scalability, and maintainability of the software.
- Restricts or enables the choice of frameworks and libraries to be used.
- Learning curve for developers not familiar with the chosen language.
