require 'rails_helper'

RSpec.feature 'CustomerRegistration', type: :feature do
  before do
    page.driver.header 'Accept-Language', locale
    I18n.locale = locale
  end

  [:en, :de].each do |locale|

    context "when the user has set their locale to #{locale}" do
      let!(:store) { create :store }
      let(:locale) { locale }

      scenario 'customer should be able to register' do

        reset_mailer

        visit spree.signup_path
        email = Faker::Internet.email
        fill_in 'spree_user[email]', with: email
        password = Faker::Internet.password(8,32)
        fill_in 'spree_user[password]', with: password
        fill_in 'spree_user[password_confirmation]', with: password
        check 'spree_user[terms_and_services]'
        check 'spree_user[privacy_and_conditions]'
        click_button Spree.t(:create)

        within('body') do
          expect(page).to have_content I18n.t('devise.user_registrations.signed_up')
        end

        user = Spree::User.last
        expect(user).to be
        expect(user.email).to eq(email)

        expect(unread_emails_for(user.email).size).to be >= parse_email_count(1)
        email = open_email(user.email)
        expect(email.body).to be
        click_first_link_in_email

        within('body') do
          expect(page).to have_content I18n.t('devise.user_confirmations.spree_user.confirmed')
        end
      end

      scenario 'customer should not be able to register without matching passwords' do

        reset_mailer

        visit spree.signup_path
        fill_in 'spree_user[email]', with: Faker::Internet.email
        fill_in 'spree_user[password]', with: Faker::Internet.password(8,32)
        fill_in 'spree_user[password_confirmation]', with: Faker::Internet.password(8,32)
        check 'spree_user[terms_and_services]'
        check 'spree_user[privacy_and_conditions]'
        click_button Spree.t(:create)

        within('body') do
          expect(page).not_to have_content I18n.t('devise.user_registrations.signed_up')
        end
      end

      scenario 'customer should not be able to register without accepting terms and privacy' do

        reset_mailer

        visit spree.signup_path
        fill_in 'spree_user[email]', with: Faker::Internet.email
        password = Faker::Internet.password(8,32)
        fill_in 'spree_user[password]', with: password
        fill_in 'spree_user[password_confirmation]', with: password
        click_button Spree.t(:create)

        within('body') do
          expect(page).not_to have_content I18n.t('devise.user_registrations.signed_up')
        end
      end

    end

  end

end
