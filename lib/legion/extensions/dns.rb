# frozen_string_literal: true

require 'legion/extensions/dns/version'
require 'legion/extensions/dns/helpers/client'
require 'legion/extensions/dns/runners/lookup'
require 'legion/extensions/dns/runners/reverse'
require 'legion/extensions/dns/client'

module Legion
  module Extensions
    module Dns
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
