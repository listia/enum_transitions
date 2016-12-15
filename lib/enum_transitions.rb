require "enum_transitions/version"

module EnumTransitions
  InvalidEnumTransition = Class.new(StandardError)

  def self.extended(mod)
    mod.class_eval do
      class_attribute :defined_enum_transitions, instance_writer: false
      self.defined_enum_transitions = {}
    end
  end

  def inherited(base) # :nodoc:
    super
    base.defined_enum_transitions = defined_enum_transitions.deep_dup
  end

  def enum_transitions(definitions)
    mod = Module.new

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
        mod.module_eval do
          define_method("#{state}!") {
            unless public_send("transitions_to_#{state}?")
              raise InvalidEnumTransition, "Cannot transition #{name} from `#{public_send(name)}` to `#{state}`"
            end
            super()
          }

          define_method("transitions_to_#{state}?") {
            defined_enum_transitions[name.to_s].map do |origin, destination|
              origin if destination.include?(state)
            end.compact.include?(public_send(name))
          }
        end
      end

      defined_enum_transitions[name.to_s] = transition_values
    end

    if mod.instance_methods.any?
      include mod
    end
  end
end

require "enum_transitions/railtie"
