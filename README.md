# lex-dns

LegionIO extension for DNS resolution via Ruby stdlib `Resolv::DNS`. No external runtime dependencies.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-dns'
```

## Standalone Usage

```ruby
require 'legion/extensions/dns'

client = Legion::Extensions::Dns::Client.new
# or with custom nameservers:
client = Legion::Extensions::Dns::Client.new(nameserver: ['8.8.8.8', '8.8.4.4'])

client.resolve_a(hostname: 'example.com')
# => { result: ['93.184.216.34'] }

client.resolve_aaaa(hostname: 'example.com')
# => { result: ['2606:2800:220:1:248:1893:25c8:1946'] }

client.resolve_cname(hostname: 'www.example.com')
# => { result: 'example.com' }

client.resolve_mx(hostname: 'example.com')
# => { result: [{ priority: 10, exchange: 'mail.example.com' }] }

client.resolve_txt(hostname: 'example.com')
# => { result: ['v=spf1 ...'] }

client.resolve_srv(hostname: '_https._tcp.example.com')
# => { result: [{ priority: 10, weight: 20, port: 443, target: 'host.example.com' }] }

client.reverse_lookup(ip: '93.184.216.34')
# => { result: 'host.example.com' }
```

## Runners

### Lookup

| Method | Arguments | Returns |
|--------|-----------|---------|
| `resolve_a` | `hostname:` | `{ result: [String] }` — IPv4 addresses |
| `resolve_aaaa` | `hostname:` | `{ result: [String] }` — IPv6 addresses |
| `resolve_cname` | `hostname:` | `{ result: String \| nil }` — canonical name |
| `resolve_mx` | `hostname:` | `{ result: [{ priority:, exchange: }] }` |
| `resolve_txt` | `hostname:` | `{ result: [String] }` |
| `resolve_srv` | `hostname:` | `{ result: [{ priority:, weight:, port:, target: }] }` |

### Reverse

| Method | Arguments | Returns |
|--------|-----------|---------|
| `reverse_lookup` | `ip:` | `{ result: String \| nil }` — PTR hostname |

## Settings

```json
{
  "lex-dns": {
    "nameserver": ["8.8.8.8", "8.8.4.4"]
  }
}
```

## License

MIT
