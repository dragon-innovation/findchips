require 'findchips/util/configuration'
require 'findchips/legacy/client'
require 'findchips/version'
require 'forwardable'
require 'json'
require 'net/http'

module Findchips
  extend SingleForwardable

  def_delegators :configuration, :auth_token

  def self.configure(&block)
    yield configuration
  end

  def self.configuration
    @configuration ||= Util::Configuration.new
  end

  private_class_method :configuration
end
