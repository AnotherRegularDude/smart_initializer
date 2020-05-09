# frozen_string_literal: true

require 'smart_core'
require 'smart_core/types'
require 'forwardable'

# @api public
# @since 0.1.0
module SmartCore
  # @api public
  # @since 0.1.0
  module Initializer
    require_relative 'initializer/version'
    require_relative 'initializer/errors'
    require_relative 'initializer/plugins'
    require_relative 'initializer/settings'
    require_relative 'initializer/configurable_module'
    require_relative 'initializer/configuration'
    require_relative 'initializer/type_system'
    require_relative 'initializer/attribute'
    require_relative 'initializer/extensions'
    require_relative 'initializer/constructor'
    require_relative 'initializer/dsl'

    # @api public
    # @since 0.1.0
    extend Plugins::AccessMixin

    class << self
      # @param base_klass [Class]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def included(base_klass)
        base_klass.extend(SmartCore::Initializer::DSL)
      end
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(*); end
  end

  class << self
    # @option type_system [String, Symbol, NilSymbol]
    # @return [Module]
    #
    # @api public
    # @since 0.1.0
    # rubocop:disable Naming/MethodName
    def Initializer(type_system: SmartCore::Initializer::ConfigurableModule::INITIAL_TYPE_SYSTEM)
      SmartCore::Initializer::ConfigurableModule.build(type_system: type_system)
    end
    # rubocop:enable Naming/MethodName
  end
end
