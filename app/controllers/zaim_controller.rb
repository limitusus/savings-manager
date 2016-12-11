require 'zaim/client'

class ZaimController < ApplicationController
  def initialize
    credentials = {
      client_key: Rails.application.secrets.zaim_client_key,
      client_secret: Rails.application.secrets.zaim_client_secret,
      zaim_token: Rails.application.secrets.zaim_token,
      zaim_secret: Rails.application.secrets.zaim_secret,
    }
    @client = Zaim::Client.new(credentials)
    super
  end

  def zaim
  end

  def accounts
    @accounts = @client.accounts
  end

  def genres
    @genres = @client.genres
    @category_ids = @genres['genres'].map { |g| g['category_id'] }.uniq.sort
    @parents_gids = @genres['genres'].map { |g| g['parent_genre_id'] }.uniq.sort
  end

  def transactions
    @transactions = @client.money['money']
  end

  def common_account_transactions
    @target_account_id = Rails.application.secrets.target_account_id
    @transactions = @client.money['money'].select { |tx|
      tx['from_account_id'] == @target_account_id ||
        tx['to_account_id'] == @target_account_id
    }
    @sum = @transactions.reduce(0) { |r, tx|
      r + (tx['from_account_id'] == @target_account_id ? -1 : 1) * tx['amount']
    }
  end
end
