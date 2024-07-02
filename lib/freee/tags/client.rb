
module Freee
  module Api
    class Tags
      BASE_URL = 'https://api.freee.co.jp'
      PATH = '/api/1/segments/1/tags'

      def initialize
        @client = Faraday.new(url: BASE_URL) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # タグ一覧の取得
      def get_tags(access_token, company_id)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        
        response = @client.get(PATH, { company_id: company_id }, 'Authorization' => "Bearer #{access_token}")
        handle_response(response, 'fetch')
      end

      # タグの作成
      def post_tags(access_token, data)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        
        response = @client.post(PATH, data.to_json, 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json')
        handle_response(response, 'create')
      end

      private

      def handle_response(response, action)
        case response.status
        when 200, 201
          if action == 'fetch'
            Rails.logger.info "Tags fetched successfully: #{response.body}"
            response.body
          elsif action == 'create'
            Rails.logger.info "Successfully created tag: segment_tag_id=#{response.body.dig('segment_tag', 'id')}"
            response.body.dig('segment_tag', 'id')
          end
        else
          Rails.logger.error "Failed to #{action} tags: #{response.body}"
          nil
        end
      end
    end
  end
end
