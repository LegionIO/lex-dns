# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/dns/helpers/client'
require 'legion/extensions/dns/runners/lookup'

RSpec.describe Legion::Extensions::Dns::Runners::Lookup do
  let(:resolver_double) { instance_double(Resolv::DNS) }

  let(:runner_class) do
    rdouble = resolver_double
    Class.new do
      include Legion::Extensions::Dns::Runners::Lookup

      define_method(:resolver) { |**_opts| rdouble }
    end
  end

  let(:runner) { runner_class.new }

  describe '#resolve_a' do
    it 'returns an array of IPv4 addresses' do
      addr = instance_double(Resolv::IPv4, to_s: '93.184.216.34')
      record = instance_double(Resolv::DNS::Resource::IN::A, address: addr)
      allow(resolver_double).to receive(:getresources)
        .with('example.com', Resolv::DNS::Resource::IN::A)
        .and_return([record])
      expect(runner.resolve_a(hostname: 'example.com')).to eq({ result: ['93.184.216.34'] })
    end

    it 'returns an empty array when no A records exist' do
      allow(resolver_double).to receive(:getresources)
        .with('nxdomain.invalid', Resolv::DNS::Resource::IN::A)
        .and_return([])
      expect(runner.resolve_a(hostname: 'nxdomain.invalid')).to eq({ result: [] })
    end
  end

  describe '#resolve_aaaa' do
    it 'returns an array of IPv6 addresses' do
      addr = instance_double(Resolv::IPv6, to_s: '2606:2800:220:1:248:1893:25c8:1946')
      record = instance_double(Resolv::DNS::Resource::IN::AAAA, address: addr)
      allow(resolver_double).to receive(:getresources)
        .with('example.com', Resolv::DNS::Resource::IN::AAAA)
        .and_return([record])
      expect(runner.resolve_aaaa(hostname: 'example.com')).to eq({ result: ['2606:2800:220:1:248:1893:25c8:1946'] })
    end

    it 'returns an empty array when no AAAA records exist' do
      allow(resolver_double).to receive(:getresources)
        .with('v4only.example', Resolv::DNS::Resource::IN::AAAA)
        .and_return([])
      expect(runner.resolve_aaaa(hostname: 'v4only.example')).to eq({ result: [] })
    end
  end

  describe '#resolve_cname' do
    it 'returns the canonical name' do
      name = instance_double(Resolv::DNS::Name, to_s: 'canonical.example.com')
      record = instance_double(Resolv::DNS::Resource::IN::CNAME, name: name)
      allow(resolver_double).to receive(:getresource)
        .with('alias.example.com', Resolv::DNS::Resource::IN::CNAME)
        .and_return(record)
      expect(runner.resolve_cname(hostname: 'alias.example.com')).to eq({ result: 'canonical.example.com' })
    end

    it 'returns nil when no CNAME record exists' do
      allow(resolver_double).to receive(:getresource)
        .with('direct.example.com', Resolv::DNS::Resource::IN::CNAME)
        .and_raise(Resolv::ResolvError)
      expect(runner.resolve_cname(hostname: 'direct.example.com')).to eq({ result: nil })
    end
  end

  describe '#resolve_mx' do
    it 'returns an array of MX hashes with priority and exchange' do
      name = instance_double(Resolv::DNS::Name, to_s: 'mail.example.com')
      record = instance_double(Resolv::DNS::Resource::IN::MX, preference: 10, exchange: name)
      allow(resolver_double).to receive(:getresources)
        .with('example.com', Resolv::DNS::Resource::IN::MX)
        .and_return([record])
      expect(runner.resolve_mx(hostname: 'example.com')).to eq(
        { result: [{ priority: 10, exchange: 'mail.example.com' }] }
      )
    end

    it 'returns an empty array when no MX records exist' do
      allow(resolver_double).to receive(:getresources)
        .with('nomx.example', Resolv::DNS::Resource::IN::MX)
        .and_return([])
      expect(runner.resolve_mx(hostname: 'nomx.example')).to eq({ result: [] })
    end
  end

  describe '#resolve_txt' do
    it 'returns an array of TXT strings' do
      record = instance_double(Resolv::DNS::Resource::IN::TXT, strings: ['v=spf1 include:example.com ~all'])
      allow(resolver_double).to receive(:getresources)
        .with('example.com', Resolv::DNS::Resource::IN::TXT)
        .and_return([record])
      expect(runner.resolve_txt(hostname: 'example.com')).to eq(
        { result: ['v=spf1 include:example.com ~all'] }
      )
    end

    it 'joins multiple string chunks in a single record' do
      record = instance_double(Resolv::DNS::Resource::IN::TXT, strings: %w[chunk1 chunk2])
      allow(resolver_double).to receive(:getresources)
        .with('example.com', Resolv::DNS::Resource::IN::TXT)
        .and_return([record])
      expect(runner.resolve_txt(hostname: 'example.com')).to eq({ result: ['chunk1chunk2'] })
    end
  end

  describe '#resolve_srv' do
    it 'returns an array of SRV hashes' do
      target = instance_double(Resolv::DNS::Name, to_s: 'host.example.com')
      record = instance_double(
        Resolv::DNS::Resource::IN::SRV,
        priority: 10,
        weight:   20,
        port:     443,
        target:   target
      )
      allow(resolver_double).to receive(:getresources)
        .with('_https._tcp.example.com', Resolv::DNS::Resource::IN::SRV)
        .and_return([record])
      expect(runner.resolve_srv(hostname: '_https._tcp.example.com')).to eq(
        { result: [{ priority: 10, weight: 20, port: 443, target: 'host.example.com' }] }
      )
    end

    it 'returns an empty array when no SRV records exist' do
      allow(resolver_double).to receive(:getresources)
        .with('_none._tcp.example.com', Resolv::DNS::Resource::IN::SRV)
        .and_return([])
      expect(runner.resolve_srv(hostname: '_none._tcp.example.com')).to eq({ result: [] })
    end
  end
end
