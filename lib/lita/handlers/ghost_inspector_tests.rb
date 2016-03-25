require 'lita-ghost-inspector/config'
require 'lita-ghost-inspector/api'
require 'lita-ghost-inspector/utility'

module Lita
  module Handlers
    class GhostInspectorTests < Handler
      include LitaGhostInspector::Config
      include LitaGhostInspector::API
      include LitaGhostInspector::Utility

      route(/^gi tests list$/, :list, command: true, help: {
        "gi tests list" => "Lists GhostInspector Tests"
      })

      def list(response)
        tests = gi_get "/tests"
        tests_response = tests.map{ |test|
          "`#{test["_id"]}` - " +
          "#{test["name"]} - " +
          "#{test["passing"] ? "Passing" : "*Not passing*"}" +
          " with screenshot " +
          "#{test["screenshotComparePassing"] ? "passing" : "*not passing*"}" +
          ". " +
          "Runs #{seconds_to_human test["testFrequency"]}. "
        }
        response.reply tests_response.join "\n"
      end

      route(/^gi tests execute\s(.+)/, :execute, command: true, help: {
        "gi tests execute robot dance" => "Executes a GhostInspector test by partial name match or id"
      })

      def execute(response)
        test_name = response.matches[0][0]
        test_ids = test_ids_by_name test_name
        test_ids = [test_name] unless test_ids.any?
        execute_response = test_ids.map do |test_id|
          execute_response = gi_get "/tests/#{test_id}/execute", immediate: true
          if execute_response == {}
            test = test(test_id) || test(test_ids_by_name(test_id)[0])
            "#{test["name"]} (#{test["_id"]})"
          end
        end.join ", "

        response.reply "Started #{execute_response}..."
      rescue Exception => e
        response.reply "GhostInspector Test Execute failed: #{e}"
      end

      Lita.register_handler(self)

      private

      def test(id)
        tests.find{|test| test["_id"] == id }
      end

      def tests
        @tests ||= gi_get "/tests"
      end

      def test_ids_by_name(test_name)
        tests.select{|test| test["name"].match test_name }.map{|h| h["_id"]}
      end
    end
  end
end
