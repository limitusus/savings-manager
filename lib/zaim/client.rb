require 'oauth'
require 'oauth/request_proxy/typhoeus_request'
require 'json'

module Zaim
  API_URL_BASE = "https://api.zaim.net"
  REQUEST_URL = "https://api.zaim.net/v2/auth/request"
  AUTHZ_URL = "https://auth.zaim.net/users/auth"
  ACCESS_TOKEN_URL = "https://api.zaim.net/v2/auth/access"

  class Client
    def initialize(credentials)
      @credentials = credentials
      @hydra = Typhoeus::Hydra.new
    end

    def accounts
      oauth_request_get('/v2/home/account')
    end

    def genres
      oauth_request_get('/v2/home/genre')
    end

    def money(params: {})
      oauth_request_get('/v2/home/money', params: params)
    end

    private
    def oauth_request_get(path, params: {})
      uri = build_uri(path)
      req = Typhoeus::Request.new(uri, { method: 'GET' })
      oauth_helper = OAuth::Client::Helper.new(req, oauth_params.merge(request_uri: uri))
      req.options[:headers].merge!({ "Authorization" => oauth_helper.header })
      @hydra.queue(req)
      @hydra.run
      res = access_token.get(uri)
      body = res.body
      return JSON.parse(body)
    end

    def build_uri(path)
      API_URL_BASE + path
    end

    def consumer
      client_key = @credentials[:client_key]
      client_secret = @credentials[:client_secret]
      if @consumer.nil?
        @consumer = OAuth::Consumer.new(
          client_key,
          client_secret,
          {
            site: API_URL_BASE,
            access_token_url: ACCESS_TOKEN_URL,
            authorize_url: AUTHZ_URL,
            request_token_url: REQUEST_URL,
          }
        )
      end
      @consumer
    end

    # UNUSED yet
    def request_token
      hash = {
        oauth_token: @credentials[:zaim_token],
        oauth_token_secret: @credentials[:zaim_secret],
      }
      if @request_token.nil?
        @request_token = OAuth::RequestToken.from_hash(consumer, hash)
      end
      @request_token
    end

    def oauth_params
      {
        consumer: consumer,
        token: access_token,
      }
    end

    def access_token
      # already have OAuth token and secret
      if @access_token.nil?
        @access_token = OAuth::AccessToken.new(
          consumer,
          @credentials[:zaim_token],
          @credentials[:zaim_secret]
        )
      end
      @access_token
    end
  end
end
