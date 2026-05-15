# homebrew-tsl-to-nss

Homebrew tap for `tsl-to-nss`, a tool that imports certificates from a
[Trust-service Status List (TSL)](https://en.wikipedia.org/wiki/Trust_service_provider#Trust_lists)
into an [NSS](https://firefox-source-docs.mozilla.org/security/nss/index.html) certificate database.

Root (self-signed) certificates are imported as trusted CAs (`CT,CT,CT`) for
TLS, S/MIME, and object signing. Non-root certificates are imported without
trust flags so they are available for chain building but not explicitly trusted.

## Installation

```sh
brew tap anvera/tsl-to-nss
brew install tsl-to-nss
```

## Usage

```
tsl-to-nss [-h] <tsl-source> <nss-db-dir>

  tsl-source  URL (http:// or https://) or local file path of a TSL XML file
  nss-db-dir  Path to an NSS database directory (created if missing,
              no password protection)
```

### Examples

Import the Chilean TSL into a new database:

```sh
tsl-to-nss https://example.cl/CL-TSL.xml ~/.nss-cl
```

Import from a locally downloaded file:

```sh
tsl-to-nss ~/Downloads/CL-TSL-VI6.xml ~/.nss-cl
```

## Dependencies

- [`tsl-extract`](https://github.com/anvera/homebrew-tsl-extract) — extracts certificates from TSL XML files
- `nss` — provides `certutil` for NSS database management

Both are installed automatically as Homebrew dependencies.

## License

MIT
