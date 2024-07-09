# frozen_string_literal: true

module Freee
  module Api
    class Tags
      PATH = '/api/1/segments/1/tags'
      PATH.freeze

      def initialize
        @client = Faraday.new(url: Parameter::SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # タグ一覧の取得
      def get_tags(access_token, params)
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

      # タグの作成
      def create_tag(access_token, params)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        raise '収入・支出の発生日が指定されていません' unless params.key?(:issue_date)
        raise '収支区分が指定されていません' unless params.key?(:type)
        raise '事業所IDが設定されていません' unless params.key?(:company_id)
        @client.authorization :Bearer, access_token
        response = @client.post do |req|
          req.url PATH
          req.body = params.to_json
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
