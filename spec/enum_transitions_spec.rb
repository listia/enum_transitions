require "rails_helper"

describe EnumTransitions do
  let(:model_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = "enum_state_models"
    end
  end


  before do
    model_class.enum(
      state: {
        pending: 0,
        processing: 1,
        completed: 2,
        failed: 3
      }
    )
  end

  context ".enum_transitions" do
    context "when enum was not defined" do
      it "raises error" do
        expect {
          model_class.enum_transitions(status: {})
        }.to raise_error(RuntimeError, "status enum is not defined")
      end
    end

    context "when transition has not defined enum key" do
      it "raises error" do
        expect {
          model_class.enum_transitions(state: { foo: :bar })
        }.to raise_error(RuntimeError, "state enum does not define: bar and foo")
      end
    end

    context "when transition is not defined" do
      it "raises InvalidEnumTransition error" do
        expect {
          model_class.enum_transitions(state: { pending: :processing })
          model = model_class.new
          model.completed!
        }.to raise_error(EnumTransitions::InvalidEnumTransition, "Cannot transition state from `pending` to `completed`")
      end
    end

    context "when transition is defined" do
      it "transits" do
        model_class.enum_transitions(state: { pending: :processing })
        model = model_class.new
        model.processing!

        expect(model.processing?).to eq(true)
      end
    end
  end
end
