require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it do
    is_expected.to validate_inclusion_of(:category)
      .in_array(%w(markup tools brushes))
      .allow_nil
  end

end
