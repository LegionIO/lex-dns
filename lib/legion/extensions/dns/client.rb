# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/lookup'
require_relative 'runners/reverse'

module Legion
  module Extensions
    module Dns
      class Client
        include Runners::Lookup
        include Runners::Reverse

        attr_reader :opts

        def initialize(nameserver: nil, **extra)
          @opts = extra
          @opts[:nameserver] = nameserver if nameserver
        end

        def resolver(**override)
          Helpers::Client.resolver(**@opts, **override)
        end
      end
    end
  end
end
