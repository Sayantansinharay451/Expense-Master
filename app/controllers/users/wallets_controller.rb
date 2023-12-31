# frozen_string_literal: true

module Users
  # Controller for managing wallets for users.
  class WalletsController < ApplicationController
    before_action :authenticate_user

    def index
      @wallets = Current.user.wallets.order(month: :asc)
      @total_amount = Wallet.total_amount_for_current_year(Current.user)
    end

    def new
      @wallet = Wallet.new
    end

    def create
      @wallet = Current.user.wallets.build(wallet_params)
      @wallet.year = Time.now.year
      if @wallet.save
        redirect_to wallets_path, success: 'Wallet created successfully.'
      else
        handle_failed_wallet_creation
      end
    end

    private

    def wallet_params
      params.require(:wallet).permit(:amount, :month)
    end

    def handle_failed_wallet_creation
      flash.now[:danger] = 'Wallet could not be created.'
      render :new
    end
  end
end
