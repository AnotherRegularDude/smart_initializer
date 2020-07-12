# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::DSL
  require_relative 'dsl/inheritance'

  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def extended(base_klass)
      base_klass.instance_eval do
        instance_variable_set(:@__params__, SmartCore::Initializer::Attribute::List.new)
        instance_variable_set(:@__options__, SmartCore::Initializer::Attribute::List.new)
        instance_variable_set(:@__init_extensions__, SmartCore::Initializer::Extensions::List.new)
        instance_variable_set(:@__definer__, SmartCore::Initializer::Constructor::Definer.new(self))
        instance_variable_set(:@__deflock__, SmartCore::Engine::Lock.new)
        instance_variable_set(:@__initializer_settings__, SmartCore::Initializer::Settings.new)
      end
      base_klass.extend(ClassMethods)
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassInheritance
    # @param child_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    # @version 0.3.1
    def inherited(child_klass)
      child_klass.instance_eval do
        instance_variable_set(:@__params__, SmartCore::Initializer::Attribute::List.new)
        instance_variable_set(:@__options__, SmartCore::Initializer::Attribute::List.new)
        instance_variable_set(:@__init_extensions__, SmartCore::Initializer::Extensions::List.new)
        instance_variable_set(:@__definer__, SmartCore::Initializer::Constructor::Definer.new(self))
        instance_variable_set(:@__deflock__, SmartCore::Engine::Lock.new)
        instance_variable_set(:@__initializer_settings__, __initializer_settings__.dup)
      end
      child_klass.extend(ClassMethods)
      SmartCore::Initializer::DSL::Inheritance.inherit(base: self, child: child_klass)
      child_klass.singleton_class.prepend(ClassInheritance)
      super
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [SmartCore::Initializer::Attribute::List]
    #
    # @api private
    # @since 0.1.0
    def __params__
      @__params__
    end

    # @return [SmartCore::Initializer::Attribute::List]
    #
    # @api private
    # @since 0.1.0
    def __options__
      @__options__
    end

    # @return [SmartCore::Initializer::Extentions::List]
    #
    # @api private
    # @since 0.1.0
    def __init_extensions__
      @__init_extensions__
    end

    # @return [SmartCore::Initializer::Attribute::Definer]
    #
    # @api private
    # @since 0.1.0
    def __definer__
      @__definer__
    end

    # @return [SmartCore::Initializer::Settings]
    #
    # @api private
    # @since 0.1.0
    def __initializer_settings__
      @__initializer_settings__
    end

    # @param arguments [Array]
    # @param block [Block]
    # @return [Any]
    #
    # @api public
    # @since 0.1.0
    def new(*arguments, &block)
      SmartCore::Initializer::Constructor.new(self, arguments, block).construct
    end

    # @param name [String, Symbol]
    # @param type [String, Symbol, Any]
    # @option cast [Boolean]
    # @option privacy [String, Symbol]
    # @option finalize [String, Symbol, Proc]
    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def param(
      name,
      type = __initializer_settings__.generic_type_object,
      privacy: SmartCore::Initializer::Attribute::Parameters::DEFAULT_PRIVACY_MODE,
      finalize: SmartCore::Initializer::Attribute::Parameters::DEFAULT_FINALIZER,
      cast: SmartCore::Initializer::Attribute::Parameters::DEFAULT_CAST_BEHAVIOUR,
      type_system: __initializer_settings__.type_system,
      **dynamic_options
    )
      __definer__.define_parameter(
        name, type, type_system, privacy, finalize, cast, dynamic_options
      )
    end

    # @param names [Array<String, Symbol>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def params(*names)
      __definer__.define_parameters(*names)
    end

    # @param name [String, Symbol]
    # @param type [String, Symbol, Any]
    # @option cast [Boolean]
    # @option privacy [String, Symbol]
    # @option finalize [String, Symbol, Proc]
    # @option type_system [String, Symbol]
    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def option(
      name,
      type = __initializer_settings__.generic_type_object,
      privacy: SmartCore::Initializer::Attribute::Parameters::DEFAULT_PRIVACY_MODE,
      finalize: SmartCore::Initializer::Attribute::Parameters::DEFAULT_FINALIZER,
      cast: SmartCore::Initializer::Attribute::Parameters::DEFAULT_CAST_BEHAVIOUR,
      type_system: __initializer_settings__.type_system,
      **dynamic_options
    )
      __definer__.define_option(
        name, type, type_system, privacy, finalize, cast, dynamic_options
      )
    end

    # @param names [Array<String, Symbol>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def options(*names)
      __definer__.define_options(*names)
    end

    # @param block [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def ext_init(&block)
      __definer__.define_init_extension(block)
    end
    alias_method :extend_initialization_flow, :ext_init
  end
end
