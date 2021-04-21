# frozen_string_literal: true

module Freee
  module Api
    class Walletables
      # 口座取得用PATH
      PATH = '/api/1/walletables'
      PATH.freeze

      # A new instance of HTTP Client.
      def initialize
        @client = Faraday.new(url: Parameter::SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # 口座一覧の取得
      # https://developer.freee.co.jp/docs/accounting/reference#/Walletables/get_walletables
      # @param access_token [String] アクセストークン
      # @param params [Hash] 取得用のパラメータ
      # @return [Hash] 口座一覧取得の結果
      def get_walletables(access_token, params)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        raise '事業所IDが設定されていません' unless params.key?(:company_id)
        @client.authorization :Bearer, access_token
        response = @client.get do |req|
          req.url PATH
          req.params = params
        end
        case response.status
        when 400
          raise StandardError, response.body
        when 401
          raise 'Unauthorized'
        end
        response
      end
    end
  end
end
