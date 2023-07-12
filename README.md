# Beep Boop

A little adventure in modern web development.

## Requirements

* `python` (Python 3.7 up to 3.11 supported)
* `pip` (Python package manager)
* `Docker`
* `terraform`
* `go` (GoLang)
* `java` (Java 8 or higher)

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/yourusername/beep-boop.git
cd beep-boop
```

2. Install the Python dependencies with pip:

```bash
pip install -r requirements.txt
```

3. Ensure Local Stack was installed correctly:

```bash
localstack --version
```

4. Read the Terraform documentation and set local variables in `terraform.tfvars`.

- [Frontend](/frontend/README.md)
- [Backend](/backend/README.md)

5. Next initialize the Terraform working directory, installing dependencies:

    terraform init

6. Finally run the plan and apply commands.
    
    terraform plan    #=> generates an execution plan.
    terraform apply   #=> builds infrastructure on AWS.

## Common Commands

```bash
# Install all dependencies
npm install:all

# Start the Next.js application.
npm run dev:frontend

# Run tests.
npm run tests
```

## Troubleshooting

```bash
# Read Docker logs of Local Stack instance.
docker logs --follow localstack_main

# Print Docker Socket information.
docker context list
```

## Documentation

Key architectural decisions are documented in the `docs/decisions` directory.
[Start here.](docs/decisions/00-record-architecture-decisions.md)

## License

This project is __FREE__ to use, reuse, remix, and resell.
This is made possible by the [MIT license](/LICENSE).
