# lex-dns: DNS Resolution Extension for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension for DNS resolution via Ruby stdlib `Resolv::DNS`. Provides forward lookups (A, AAAA, CNAME, MX, TXT, SRV) and reverse PTR lookups. No external runtime dependencies.

**GitHub**: https://github.com/LegionIO/lex-dns
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::Dns
├── Runners/
│   ├── Lookup     # resolve_a, resolve_aaaa, resolve_cname, resolve_mx, resolve_txt, resolve_srv
│   └── Reverse    # reverse_lookup (PTR)
├── Helpers/
│   └── Client     # Resolv::DNS instance factory (configurable nameservers)
└── Client         # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/dns.rb` | Entry point, extension registration, default settings |
| `lib/legion/extensions/dns/runners/lookup.rb` | Forward DNS resolution methods |
| `lib/legion/extensions/dns/runners/reverse.rb` | PTR reverse lookup |
| `lib/legion/extensions/dns/helpers/client.rb` | Resolv::DNS connection helper |
| `lib/legion/extensions/dns/client.rb` | Standalone Client class |

## Settings

```json
{
  "lex-dns": {
    "nameserver": ["8.8.8.8", "8.8.4.4"]
  }
}
```

## Dependencies

No runtime gem dependencies. Uses Ruby stdlib `resolv`.

## Development

29 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
