# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/dns/helpers/client'
require 'legion/extensions/dns/runners/reverse'

RSpec.describe Legion::Extensions::Dns::Runners::Reverse do
  let(:resolver_double) { instance_double(Resolv::DNS) }

  let(:runner_class) do
    rdouble = resolver_double
    Class.new do
      include Legion::Extensions::Dns::Runners::Reverse

      define_method(:resolver) { |**_opts| rdouble }
    end
  end

  let(:runner) { runner_class.new }

  describe '#reverse_lookup' do
    it 'returns the hostname for the given IP' do
      name = instance_double(Resolv::DNS::Name, to_s: 'host.example.com')
      allow(resolver_double).to receive(:getname).with('93.184.216.34').and_return(name)
      expect(runner.reverse_lookup(ip: '93.184.216.34')).to eq({ result: 'host.example.com' })
    end

    it 'returns nil when the IP has no PTR record' do
      allow(resolver_double).to receive(:getname).with('10.0.0.1').and_raise(Resolv::ResolvError)
      expect(runner.reverse_lookup(ip: '10.0.0.1')).to eq({ result: nil })
    end
  end
end
