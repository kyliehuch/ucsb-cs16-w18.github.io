module GitHubPages
  module HealthCheck
    module Errors
      class MissingAccessTokenError < GitHubPages::HealthCheck::Error
        def message
          "Cannot retrieve repository information with a valid access token"
        end
      end
    end
  end
end
