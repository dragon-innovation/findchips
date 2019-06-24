require 'json'
require 'net/http'

module Findchips
  module Legacy
    class Client
      attr_reader :auth_token
      attr_reader :options

      FINDCHIPS_HOST = 'api.findchips.com'.freeze
      PART_MATCH_LIMIT = 1

      def initialize(opts = nil)
        @options = {
          api_key: Findchips.auth_token,
          debug: false,
        }.merge(opts || {})

        if Findchips.auth_token.nil? || Findchips.auth_token == ''
          raise ArgumentError, ':auth_token is required'
        end

        log_message(@options)
      end

      # Refactor: parametrize the version, once SupplyFrame versions their API
      def search(mpn, **params)
        get('/v1/search', part: mpn, **params) do |response|
          JSON.parse(response.body)
        end
      end

      protected

      def get(path, **params, &block)
        request = build_request(:get, path, **params)
        response = issue_request(request)
        handle_response(request, response, &block)
      end

      def issue_request(request)
        http = Net::HTTP.new(request.uri.host, request.uri.port)
        http.use_ssl = true
        http.request(request)
      end

      def build_request(method, path, **params)
        uri = build_uri(path, params)
        log_message(uri)
        case method
        when :get then Net::HTTP::Get.new(uri)
        else
          raise ArgumentError, "Unknown HTTP method: #{method}"
        end
      end

      def build_uri(path, **params)
        URI::HTTPS.build(
          host: FINDCHIPS_HOST,
          path: path,
          query: URI.encode_www_form({

            apiKey: @options[:api_key],
          }.merge(params))
        )
      end

      def handle_response(request, response, &_block)
        case response
        when Net::HTTPSuccess # 2XX
          yield(response)
        when Net::HTTPClientError, Net::HTTPServerError # 4XX, 5XX
          log_request(request)
          log_response(response)
          raise_response_error(response)
        else
          log_request(request)
          log_response(response)
          raise_response_error(response)
        end
      end

      def raise_response_error(response)
        case response.code
        when '404' then raise NotFoundError, response.message
        when '409' then raise ConflictError, response.message
        else
          raise "Unexpected Response (#{response.code}): #{response.message}"
        end
      end

      def log_message(message)
        return unless options[:debug]
        ap message
      end

      def log_request(request)
        return unless options[:debug]
        ap [request.method, request.uri, request, request.body]
      end

      def log_response(response)
        return unless options[:debug]
        ap [response, response.code, response.message, response.body]
      end

    end
  end
end
