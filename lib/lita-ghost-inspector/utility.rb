module LitaGhostInspector
  module Utility
    def seconds_to_human(seconds)
      {
        seconds => "every #{seconds} seconds",
        86400 => "daily",
        3600 => "hourly",
        1800 => "every 30 minutes",
        900 => "every 15 minutes",
        300 => "every 5 minutes",
        0 => "never"
      }[seconds]
    end
  end
end
