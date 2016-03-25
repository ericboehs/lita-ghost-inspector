require 'lita-ghost-inspector/config'
require 'lita-ghost-inspector/api'
require 'lita-ghost-inspector/utility'

module Lita
  module Handlers
    class GhostInspectorSuites < Handler
      include LitaGhostInspector::Config
      include LitaGhostInspector::API
      include LitaGhostInspector::Utility

      route(/^gi suites list$/, :list, command: true, help: {
        "gi suites list" => "Lists GhostInspector Suites"
      })

      def list(response)
        suites_response = suites.map{ |suite| "#{suite["name"]} - #{suite["testCount"]} tests" }
        response.reply suites_response.join "\n"
      end

      route(/^gi suites execute\s(.+)/, :execute, command: true, help: {
        "gi suites execute robot overlords" => "Executes a GhostInspector Suite by name"
      })

      def execute(response)
        suite_name = response.matches[0][0]
        suite_id = suite_id_by_name suite_name
        execute_response = gi_get "/suites/#{suite_id}/execute", immediate: true
        if execute_response == {}
          response.reply "Started #{suite_name} suite..."
        end
      end

      route(/^gi suites list tests\s(.+)/, :list_tests, command: true, help: {
        "gi suites list tests robot overlords" => "Lists tests for a GhostInspector Suite by name"
      })

      def list_tests(response)
        suite_name = response.matches[0][0]
        suite_id = suite_id_by_name suite_name
        tests = gi_get "/suites/#{suite_id}/tests"
        tests_response = tests.map{ |test|
          "#{test["name"]} - " +
          "#{test["passing"] ? "Passing" : "*Not passing*"}" +
          " with screenshot " +
          "#{test["screenshotComparePassing"] ? "passing" : "*not passing*"}" +
          ". " +
          "Runs #{seconds_to_human test["testFrequency"]}. "
        }
        response.reply tests_response.join "\n"
      end

      Lita.register_handler(self)

      private

      def suites
        @suites ||= gi_get "/suites"
      end

      def suite_id_by_name(suite_name)
        suites.find{|suite| suite["name"] == suite_name }&.[]("_id")
      end
    end
  end
end
