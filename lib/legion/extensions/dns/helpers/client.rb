# frozen_string_literal: true

require 'resolv'

module Legion
  module Extensions
    module Dns
      module Helpers
        module Client
          def self.resolver(nameserver: nil, **_opts)
            if nameserver
              servers = Array(nameserver)
              ::Resolv::DNS.new(nameserver: servers)
            else
              ::Resolv::DNS.new
            end
          end
        end
      end
    end
  end
end
