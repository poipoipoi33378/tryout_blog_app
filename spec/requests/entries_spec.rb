require 'rails_helper'

RSpec.describe "Entries", type: :request do
  describe "GET /entries" do
    it "not works! (now write some real specs)" do
      expect do
        blog = FactoryBot.create(:blog)
        get blog_entries_path(blog)
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
