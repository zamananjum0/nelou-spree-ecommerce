require 'rails_helper'

RSpec.feature 'User Password Reset', type: :feature do
  before do
    page.driver.header 'Accept-Language', locale
    I18n.locale = locale
  end

  [:en, :de].each do |locale|
    context "when the user has set their locale to #{locale}" do
      let!(:store) { create :store }
      let(:user) { create :confirmed_user }
      let(:locale) { locale }

      scenario 'they should receive an email and successfully reset password' do
        reset_mailer

        old_password = user.encrypted_password

        visit spree.reset_password_path
        fill_in 'spree_user[email]', with: user.email
        click_button Spree.t(:reset_password)

        expect(unread_emails_for(user.email).size).to be >= parse_email_count(1)
        email = open_email(user.email)
        expect(email.body).to include('reset_password_token=') # TODO: Figure out a better test for this
        click_first_link_in_email

        within('body') do
          expect(page).to have_content Spree.t(:change_your_password)
        end

        fill_in 'spree_user[password]', with: user.password
        fill_in 'spree_user[password_confirmation]',  with: user.password
        click_button Spree.t(:update)

        within('body') do
          expect(page).to have_content I18n.t('devise.user_passwords.spree_user.updated')
        end

        customer = Spree::User.find user.id
        expect(customer.encrypted_password).not_to eq(old_password)

      end
    end
  end
end
