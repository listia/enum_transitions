ActiveRecord::Schema.define(version: Time.now.strftime("%Y%m%d%H%M%S")) do
  create_table "enum_state_models", force: true do |t|
    t.integer "state", default: 0, null: false
  end
end
