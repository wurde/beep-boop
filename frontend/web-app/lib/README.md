# Libraries

## API Client

# OpenAPI Code Generator

The npm package wrapper is cross-platform wrapper around the .jar artifact.
It works by providing a CLI wrapper atop the JAR's command line options. This
gives a simple interface layer which normalizes usage of the command line
across operating systems, removing some differences in how options or switches
are passed to the tool (depending on OS).

## Dependencies

The OpenAPI Generator tool is developed in Java, so you will need to have Java
installed on your machine to use the CLI (Command Line Interface) tool.
Specifically, you need Java 8 or newer.

If you don't have Java installed, you can download it from the official Oracle
website or use an open-source version like OpenJDK. After downloading, you can
install it by following the prompts.

The Java Runtime (JRE) that you download from java.com or oracle.com contains
a plugin to run Java content from your browser. In order to use the command
line tools, you will need to download the Java Development Kit (JDK). The JRE
and JDK are separate and can coexist on your system. Only one JRE can be
installed on Mac. There can be multiple JDKs installed on a system, as many as
you wish.

- https://www.java.com/download/ie_manual.jsp
- https://www.java.com/en/download/help/version_manual.html
- https://www.oracle.com/java/technologies/downloads/#jdk20-windows

```bash
# Add "C:\Program Files\Java\jdk-20\bin" to the PATH environment variable.

java -version
```

## Setup

```bash
npm install -D @openapitools/openapi-generator-cli
```

https://openapi-generator.tech/docs/installation
