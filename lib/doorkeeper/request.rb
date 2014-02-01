require 'doorkeeper/request/authorization_code'
require 'doorkeeper/request/client_credentials'
require 'doorkeeper/request/code'
require 'doorkeeper/request/password'
require 'doorkeeper/request/refresh_token'
require 'doorkeeper/request/token'

module Doorkeeper
  module Request
    extend self

    def authorization_strategy(strategy)
      # OLD CODE: get_strategy strategy, %w[code token]
      get_strategy strategy, Doorkeeper.configuration.authorization_response_types
    rescue NameError
      raise Errors::InvalidAuthorizationStrategy
    end

    def token_strategy(strategy)
      # OLD CODE: get_strategy strategy, %w[password client_credentials authorization_code refresh_token]
      get_strategy strategy, Doorkeeper.configuration.token_grant_types
    rescue NameError
      raise Errors::InvalidTokenStrategy
    end

    def get_strategy(strategy, available)
      raise Errors::MissingRequestStrategy unless strategy.present?
      # OLD CODE: raise NameError unless available.include?(strategy.to_s)
      raise NameError unless available.include?(strategy.to_sym)
      "Doorkeeper::Request::#{strategy.to_s.camelize}".constantize
    end
  end
end
