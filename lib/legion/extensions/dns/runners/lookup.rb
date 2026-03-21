# frozen_string_literal: true

require 'legion/extensions/dns/helpers/client'

module Legion
  module Extensions
    module Dns
      module Runners
        module Lookup
          def resolve_a(hostname:, **)
            records = resolver(**).getresources(hostname, ::Resolv::DNS::Resource::IN::A)
            { result: records.map(&:address).map(&:to_s) }
          end

          def resolve_aaaa(hostname:, **)
            records = resolver(**).getresources(hostname, ::Resolv::DNS::Resource::IN::AAAA)
            { result: records.map(&:address).map(&:to_s) }
          end

          def resolve_cname(hostname:, **)
            record = resolver(**).getresource(hostname, ::Resolv::DNS::Resource::IN::CNAME)
            { result: record.name.to_s }
          rescue ::Resolv::ResolvError
            { result: nil }
          end

          def resolve_mx(hostname:, **)
            records = resolver(**).getresources(hostname, ::Resolv::DNS::Resource::IN::MX)
            { result: records.map { |r| { priority: r.preference, exchange: r.exchange.to_s } } }
          end

          def resolve_txt(hostname:, **)
            records = resolver(**).getresources(hostname, ::Resolv::DNS::Resource::IN::TXT)
            { result: records.map { |r| r.strings.join } }
          end

          def resolve_srv(hostname:, **)
            records = resolver(**).getresources(hostname, ::Resolv::DNS::Resource::IN::SRV)
            {
              result: records.map do |r|
                { priority: r.priority, weight: r.weight, port: r.port, target: r.target.to_s }
              end
            }
          end

          extend Legion::Extensions::Dns::Helpers::Client
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
