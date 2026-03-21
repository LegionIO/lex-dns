# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/dns/helpers/client'

RSpec.describe Legion::Extensions::Dns::Helpers::Client do
  let(:resolver_double) { instance_double(Resolv::DNS) }

  describe '.resolver' do
    it 'returns a Resolv::DNS instance when no nameserver given' do
      allow(Resolv::DNS).to receive(:new).with(no_args).and_return(resolver_double)
      expect(described_class.resolver).to eq(resolver_double)
    end

    it 'passes nameserver array when a single string is given' do
      allow(Resolv::DNS).to receive(:new).with(nameserver: ['8.8.8.8']).and_return(resolver_double)
      result = described_class.resolver(nameserver: '8.8.8.8')
      expect(result).to eq(resolver_double)
    end

    it 'passes nameserver array when an array is given' do
      allow(Resolv::DNS).to receive(:new).with(nameserver: ['1.1.1.1', '8.8.8.8']).and_return(resolver_double)
      result = described_class.resolver(nameserver: ['1.1.1.1', '8.8.8.8'])
      expect(result).to eq(resolver_double)
    end

    it 'ignores unknown keyword arguments' do
      allow(Resolv::DNS).to receive(:new).with(no_args).and_return(resolver_double)
      expect(described_class.resolver(timeout: 5)).to eq(resolver_double)
    end
  end
end
