require "lita"
require "json"
require "http"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/ghost_inspector"
require "lita/handlers/ghost_inspector_results"
require "lita/handlers/ghost_inspector_suites"
require "lita/handlers/ghost_inspector_tests"

Lita::Handlers::GhostInspector.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
