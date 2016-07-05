require 'rails_helper'

RSpec.describe Nelou::DesignerLabel, type: :model do
  let!(:store) { create :store }
  let(:designer_label) { create :designer_label }

  it 'has a valid factory' do
    expect(designer_label).to be_valid
  end

  it 'must have a name' do
    designer_label.name = nil

    expect(designer_label).not_to be_valid
  end

end
