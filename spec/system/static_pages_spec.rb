require 'rails_helper'

RSpec.feature "Static Pages", type: :system do

  scenario 'home page' do
    visit root_path

    within 'header' do
      aggregate_failures do
        expect(page).to have_content 'TRYOUT APP'
        expect(page).to have_link "Home"
        expect(page).to have_link "Help"
        expect(page).to have_link "Log in"
      end
    end

    expect(page).to have_content "Welcome to Sample App"
    expect(page).to have_content "This is the home page for Tryout sample application"
    expect(page).to have_link "Sign up now!"

    within 'footer' do
      expect(page).to have_content "Tryout 2018.10.18 start"
      expect(page).to have_link "About"
      expect(page).to have_link "Contact"
      expect(page).to have_link "News"
    end
  end
end