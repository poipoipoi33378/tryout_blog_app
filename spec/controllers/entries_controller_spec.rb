require 'rails_helper'

RSpec.describe EntriesController, type: :controller do

  it "not returns a 200 response"do
    expect do
      get :index
    end.to raise_error(ActionController::UrlGenerationError)
  end
end
