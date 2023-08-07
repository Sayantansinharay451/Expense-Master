# rubocop:disable all

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:organization) { create(:organization) }

  it 'is valid with valid attributes' do
    user = build(:user, organization:)
    expect(user).to be_valid
  end

  it 'is not valid without a first name' do
    user = build(:user, first_name: nil, organization:)
    expect(user).not_to be_valid
  end

  it 'is not valid without a valid email' do
    user = build(:user, email: 'invalid_email', organization:)
    expect(user).not_to be_valid
  end

  it 'is not valid with a last name exceeding 20 characters' do
    user = build(:user, last_name: 'a' * 21, organization:)
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include('Last name is too long.')
  end

  it 'creates budgets associated with the user' do
    user = create(:user)
    budget = create(:budget, user:)
    expect(user.budgets).to include(budget)
  end

  it 'is not valid without a password' do
    user = build(:user, password: nil, password_confirmation: nil, organization:)
    expect(user).not_to be_valid
  end

  it 'is not valid with a short password' do
    user = build(:user, password: 'abc', password_confirmation: 'abc', organization:)
    expect(user).not_to be_valid
  end

  it 'is not valid with a weak password' do
    user = build(:user, password: 'Abc123', password_confirmation: 'Abc123', organization:)
    expect(user).not_to be_valid
  end

  it 'is valid with a strong password' do
    user = build(:user, password: 'Abc123$%^', password_confirmation: 'Abc123$%^', organization:)
    expect(user).to be_valid
  end

  it 'is not valid when password confirmation does not match password' do
    user = build(:user, password: 'Abc123$%^', password_confirmation: 'DifferentPassword', organization:)
    expect(user).not_to be_valid
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end

  it 'returns non-admin users for a given organization' do
    admin_user = create(:user, is_admin?: true, organization:)
    non_admin_user = create(:user, organization:)
    expect(User.get_non_admin_users(organization.id)).to include(non_admin_user)
    expect(User.get_non_admin_users(organization.id)).not_to include(admin_user)
  end

  it 'returns admin users for a given organization' do
    admin_user = create(:user, is_admin?: true, organization:)
    non_admin_user = create(:user, organization:)
    expect(User.get_admin_users(organization.id)).to include(admin_user)
    expect(User.get_admin_users(organization.id)).not_to include(non_admin_user)
  end

  it 'creates a user with generated password when invited by an admin' do
    admin_user = create(:user, organization:)
    invited_user = User.invite_user(admin_user, 'test@example.com')
    expect(invited_user).to be_valid
    expect(invited_user.organization_id).to eq(admin_user.organization_id)
    expect(invited_user.password).to match(User::PASSWORD_REGEX)
  end

  describe '.generate_password' do
    it 'generates passwords that match the regex pattern' do
      regex_pattern = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[[:^alnum:]])/x

      100.times do
        generated_password = User.generate_password
        expect(generated_password).to match(regex_pattern)
      end
    end
  end
end
