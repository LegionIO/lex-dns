# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/dns/client'

RSpec.describe Legion::Extensions::Dns::Client do
  let(:resolver_double) { instance_double(Resolv::DNS) }

  before do
    allow(Legion::Extensions::Dns::Helpers::Client).to receive(:resolver).and_return(resolver_double)
  end

  describe '#initialize' do
    it 'stores default empty opts when no nameserver given' do
      client = described_class.new
      expect(client.opts).to eq({})
    end

    it 'stores nameserver in opts when provided as a string' do
      client = described_class.new(nameserver: '8.8.8.8')
      expect(client.opts).to include(nameserver: '8.8.8.8')
    end

    it 'stores nameserver in opts when provided as an array' do
      client = described_class.new(nameserver: ['1.1.1.1', '8.8.8.8'])
      expect(client.opts).to include(nameserver: ['1.1.1.1', '8.8.8.8'])
    end
  end

  describe '#resolver' do
    it 'delegates to Helpers::Client.resolver with stored opts' do
      client = described_class.new(nameserver: '8.8.8.8')
      result = client.resolver
      expect(Legion::Extensions::Dns::Helpers::Client).to have_received(:resolver).with(nameserver: '8.8.8.8')
      expect(result).to eq(resolver_double)
    end

    it 'allows per-call overrides' do
      client = described_class.new(nameserver: '8.8.8.8')
      client.resolver(nameserver: '1.1.1.1')
      expect(Legion::Extensions::Dns::Helpers::Client).to have_received(:resolver).with(nameserver: '1.1.1.1')
    end
  end

  describe 'runner methods' do
    let(:client_instance) { described_class.new }

    it 'responds to Lookup runner methods' do
      expect(client_instance).to respond_to(:resolve_a, :resolve_aaaa, :resolve_cname,
                                            :resolve_mx, :resolve_txt, :resolve_srv)
    end

    it 'responds to Reverse runner method' do
      expect(client_instance).to respond_to(:reverse_lookup)
    end

    it 'can call resolve_a through the client' do
      addr = instance_double(Resolv::IPv4, to_s: '1.2.3.4')
      record = instance_double(Resolv::DNS::Resource::IN::A, address: addr)
      allow(resolver_double).to receive(:getresources)
        .with('test.example', Resolv::DNS::Resource::IN::A)
        .and_return([record])
      result = client_instance.resolve_a(hostname: 'test.example')
      expect(result[:result]).to eq(['1.2.3.4'])
    end

    it 'can call reverse_lookup through the client' do
      name = instance_double(Resolv::DNS::Name, to_s: 'ptr.example.com')
      allow(resolver_double).to receive(:getname).with('1.2.3.4').and_return(name)
      result = client_instance.reverse_lookup(ip: '1.2.3.4')
      expect(result[:result]).to eq('ptr.example.com')
    end
  end
end
