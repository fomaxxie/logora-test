# spec/models/concerns/moderable_spec.rb
require 'rails_helper'

RSpec.describe Moderable, type: :model do
  before do
    class TestModel < ApplicationRecord
      self.table_name = 'your_table_name'
      include Moderable
      moderates :content
    end
  end

  after do
    # Cleanup to avoid constant redefinition warnings
    ActiveSupport::Dependencies.remove_constant('TestModel')
  end

  describe 'moderation on save' do
    it 'sets is_accepted based on moderation result' do
      allow(ModerationService).to receive(:check_content).and_return({is_accepted: true})

      test_model = TestModel.new(content: 'Some content')
      test_model.save
      expect(test_model.is_accepted).to be true
    end
  end
end
