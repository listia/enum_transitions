require "enum_transitions/version"

module EnumTransitions
  InvalidTransition = Class.new(StandardError)

  def self.extended(base)
    base.class_attribute(:defined_enum_transitions, instance_writer: false)
    base.defined_enum_transitions = {}
  end

  def inherited(base)
    base.defined_enum_transitions = defined_enum_transitions.deep_dup
    super
  end

  def enum_transitions(definitions)
    definitions.each do |name, values|
      unless enum_definition = defined_enums[name.to_s]
        raise "#{name} enum is not defined"
      end

      transition_values = ActiveSupport::HashWithIndifferentAccess.new

      values.each do |origin, destinations|
        origin = origin.to_s
        destinations = Array.wrap(destinations).map(&:to_s)
        states_diff = (destinations + [origin]) - enum_definition.keys

        unless states_diff.empty?
          raise "#{name} enum does not define: #{states_diff.to_sentence}"
        end

        transition_values[origin] = destinations
      end

      enum_definition.keys.each do |state|
        _enum_transitions_methods_module.module_eval do
          define_method("transitions_to_#{state}?") {
            defined_enum_transitions[name.to_s].map do |origin, destination|
              origin if destination.include?(state)
            end.compact.include?(public_send(name))
          }

          define_method("#{state}!") { |*args|
            unless public_send("transitions_to_#{state}?")
              raise InvalidTransition, "Cannot transition #{name} from `#{public_send(name)}` to `#{state}`"
            end
            super(*args)
          }
        end
      end

      defined_enum_transitions[name.to_s] = transition_values
    end
  end

  private

  def _enum_transitions_methods_module
    @_enum_transitions_methods_module ||= begin
      mod = Module.new
      include mod
      mod
    end
  end
end

require "enum_transitions/railtie"
