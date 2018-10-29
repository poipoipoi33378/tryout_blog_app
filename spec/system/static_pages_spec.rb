require 'rails_helper'

RSpec.feature "Static Pages", type: :system do

  scenario 'home page' do
    visit root_path

    expect(page).to have_title 'Tryout app'

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

    expect(page).to have_link 'tryout app',href: root_path

    click_link 'Home'
    expect(page).to have_title 'Tryout app'

    click_link 'Help'
    expect(current_path).to eq help_path
    expect(page).to have_title 'Tryout app | Help'

    click_link 'About'
    expect(current_path).to eq about_path
    expect(page).to have_title 'Tryout app | About'

    expect(page).to have_link 'Contact',href: 'https://www.facebook.com/poipoipoi33378'
    expect(page).to have_link 'News',href: 'http://legacycode.hatenablog.com/'
  end
end