# Changelog

## [0.1.0] - 2026-03-21

### Added
- Initial release
- `Helpers::Client.resolver` wrapping Ruby stdlib `Resolv::DNS`; accepts optional `nameserver:` (string or array)
- `Runners::Lookup`: `resolve_a`, `resolve_aaaa`, `resolve_cname`, `resolve_mx`, `resolve_txt`, `resolve_srv`
- `Runners::Reverse`: `reverse_lookup` (IP to hostname)
- Standalone `Client` class including all runners; takes `nameserver:` kwargs at construction
- No external runtime dependencies (uses Ruby stdlib `resolv`)
