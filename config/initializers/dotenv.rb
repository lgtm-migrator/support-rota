# Require environment variables on initialisation
# https://github.com/bkeepers/dotenv#required-keys
Dotenv.require_keys("OPSGENIE_API_KEY") if defined?(Dotenv)
