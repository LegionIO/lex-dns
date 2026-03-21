# frozen_string_literal: true

require 'legion/extensions/dns/helpers/client'

module Legion
  module Extensions
    module Dns
      module Runners
        module Reverse
          def reverse_lookup(ip:, **)
            hostname = resolver(**).getname(ip).to_s
            { result: hostname }
          rescue ::Resolv::ResolvError
            { result: nil }
          end

          extend Legion::Extensions::Dns::Helpers::Client
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
