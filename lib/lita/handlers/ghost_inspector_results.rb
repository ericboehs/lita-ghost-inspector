require 'lita-ghost-inspector/config'
require 'lita-ghost-inspector/api'
require 'lita-ghost-inspector/utility'

module Lita
  module Handlers
    class GhostInspectorResults < Handler
      include LitaGhostInspector::Config
      # insert handler code here

      Lita.register_handler(self)
    end
  end
end
