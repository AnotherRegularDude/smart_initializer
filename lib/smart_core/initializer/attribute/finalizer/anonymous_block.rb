# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Finalizer
  # @pai private
  # @since 0.1.0
  class AnonymousBlock < Abstract
    # @param finalizer [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(finalizer)
      @finalizer = finalizer
    end

    # @param value [Any]
    # @param instance [Any]
    # @return [value]
    #
    # @pai private
    # @since 0.1.0
    def call(value, instance)
      instance.instance_exec(value, &finalizer)
    end

    private

    # @return [NilClass, Any]
    #
    # @api private
    # @since 0.1.0
    attr_reader :finalizer
  end
end
