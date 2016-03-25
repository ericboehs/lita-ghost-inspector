require 'lita-ghost-inspector/config'
require 'lita-ghost-inspector/api'
require 'lita-ghost-inspector/utility'

module Lita
  module Handlers
    class GhostInspector < Handler
      include LitaGhostInspector::Config

      config :api_key, required: true

      Lita.register_handler(self)
    end
  end
end
