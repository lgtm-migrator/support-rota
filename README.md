# Support Rota

A Rails app that returns the dxw Support and Out of Hours rotas from Opsgenie in iCal and JSON formats.

## Getting started

1. copy `/.env.example` into `/.env.development.local`.

    Our intention is that the example should include enough to get the application started quickly. If this is not the case, please ask another developer for a copy of their `/.env.development.local` file.

    dxw specific values are stored in the Shared 1password vault.
1. Run the server:

  ```bash
  script/server
  ```

The data is available at the following routes:

### Support rota (dev and ops eng)

- http://localhost:3000/support/rota.ics
- http://localhost:3000/support/rota.json

### Out of hours (1st and 2nd lines)

- http://localhost:3000/out-of-hours/rota.ics
- http://localhost:3000/out-of-hours/rota.json

### Developer

- http://localhost:3000/v2/dev/rota.json

### Ops engineer

- http://localhost:3000/v2/ops/rota.json

### OOH First line

- http://localhost:3000/v2/ooh1/rota.json

### OOH Second line

- http://localhost:3000/v2/ooh2/rota.json

## Running the tests

```bash
script/test
```

## Running Brakeman

Run [Brakeman](https://brakemanscanner.org/) to highlight any security vulnerabilities:

```bash
brakeman
```

To pipe the results to a file:

```bash
brakeman -o report.text
```

## Making changes

When making a change, update the [changelog](CHANGELOG.md) using the
[Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format. Pull
requests should not be merged before any relevant updates are made.

## Releasing changes

When making a new release, update the [changelog](CHANGELOG.md) in the release
pull request.

## Architecture decision records

We use ADRs to document architectural decisions that we make. They can be found
in doc/architecture/decisions and contributed to with the
[adr-tools](https://github.com/npryce/adr-tools).

## Managing environment variables

We use [Dotenv](https://github.com/bkeepers/dotenv) to manage our environment variables locally.

The repository will include safe defaults for development in `/.env.example` and for test in `/.env.test`. We use 'example' instead of 'development' (from the Dotenv docs) to be consistent with current dxw conventions and to make it more explicit that these values are not to be committed.

To manage sensitive environment variables:

1. Add the new key and safe default value to the `/.env.example` file eg. `ROLLBAR_TOKEN=ROLLBAR_TOKEN`
2. Add the new key and real value to your local `/.env.development.local` file, which should never be checked into Git. This file will look something like `ROLLBAR_TOKEN=123456789`

## Access

The app is hosted on Heroku at https://dxw-support-rota.herokuapp.com.

## Source

This repository was bootstrapped from
[dxw's `rails-template`](https://github.com/dxw/rails-template).
