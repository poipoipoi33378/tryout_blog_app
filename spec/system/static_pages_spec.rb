require 'rails_helper'

RSpec.feature "Static Pages", type: :system do

  let(:user){ FactoryBot.create(:user) }

  context 'home page' do
    scenario 'home page element without login' do
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
      expect(page).to have_link "Log in with Google"

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

    scenario 'home page element with login' do
      3.times do
        user.blogs.create(FactoryBot.attributes_for(:blog))
      end

      sign_in user

      visit root_path
      expect(page).to have_title 'Tryout app'

      expect(page).to_not have_content "Welcome to Sample App"
      expect(page).to_not have_content "This is the home page for Tryout sample application"
      expect(page).to_not have_link "Sign up now!"
      expect(page).to_not have_link "Log in with Google"

      expect(page).to have_content user.name
      expect(page).to have_link 'view my profile',href: user_path(user)
      expect(page).to have_content '3 blogs'
    end
  end

  context 'user registration' ,js: true do
    scenario 'user registration' do
      visit root_path

      expect(page).to_not have_content 'Account'
      expect(page).to_not have_content 'Profile'
      expect(page).to_not have_content 'Setting'
      expect(page).to_not have_content 'Log out'

      click_link 'Sign up now!'

      fill_in "Name",with: 'user.name'
      fill_in "Email",with: 'new_user@email.com'
      fill_in "user_password",with: 'user.password'
      fill_in "Password confirmation",with: 'user.password'

      expect do
        click_button 'Sign up'
        expect(page).to have_content 'Welcome! You have signed up successfully.'
      end.to change(User,:count).by(1)

      within 'header' do
        expect(page).to have_content 'Account'
        click_link 'Account'
        expect(page).to have_content 'Setting'
        expect(page).to have_content 'Log out'
        expect(page).to_not have_content 'Log in'
      end
    end

    # TODO テスト毎にポート番号が自動で変わるので上手くいかない。後で調べる
    # scenario 'user log in with google' do
    #   visit root_path
    #
    #   expect(page).to_not have_content 'Log out'
    #
    #   click_link 'Log in with Google'
    #
    #   expect do
    #     click_link 'seiichi sugahara'
    #   end.to change(User,:count).by(1)
    #
    #   expect(page).to have_content 'Log out'
    #
    # end

    scenario 'user log in and show profile and setting and log out' do
      visit root_path

      click_link 'Log in'

      fill_in "Email",with: user.email
      fill_in "user_password",with: user.password
      click_button 'Log in'

      within 'header' do
        expect(page).to_not have_content 'Log in'

        click_link 'Account'
        click_link 'Setting'
      end

        expect(page).to have_button 'Update'

      within 'header' do
        click_link 'Account'
        click_link 'Log out'
        expect(page).to have_content 'Log in'
      end
    end

    scenario 'user update' do
      sign_in user

      visit root_path

      click_link 'Account'
      click_link 'Setting'

      expect do
        fill_in "Name",with: 'user_test_name'
        fill_in "Email",with: 'user_test@emal.com'
        expect(page).to have_content 'Password'
        expect(page).to have_content 'Password confirmation'
        fill_in "Current password",with: user.password

        click_button 'Update'
      end.to_not change(User,:count)

      user.reload
      expect(user.name).to eq 'user_test_name'
      expect(user.email).to eq 'user_test@emal.com'

      expect(current_path).to eq root_path
    end

    scenario 'user profile' do
      sign_in user

      visit root_path

      click_link 'Account'
      click_link 'Profile'

      expect(page).to have_content user.name
    end
  end
end