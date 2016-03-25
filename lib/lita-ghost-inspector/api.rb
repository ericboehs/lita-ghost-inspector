module LitaGhostInspector
  module API
    def gi_get(url, params={})
      gi_api :get, url, params: merge_api_key(params)
    end

    def gi_api(action, url, *args)
      JSON.parse(
        HTTP.send(action, "https://api.ghostinspector.com/v1#{url}", *args).tap do |response|
          unless response.to_s.start_with? '{"code":"SUCCESS"'
            response = JSON.parse response
            raise "GhostInspector API Error: #{response["errorType"]} #{response["message"]}"
          end

          unless response.code.to_s.match(/^[2|3]/)
            raise "GhostInspector API Response Code #{response.code}"
          end
        end
      )["data"]
    end

    protected

    def merge_api_key(params)
      { apiKey: config.api_key }.merge params
    end
  end
end
