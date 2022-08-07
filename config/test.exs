import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mypcstmr, MypcstmrWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5KJnHeFMEeTb8wxCfAnRP7y37Fd8wXiogKyRFGtl0+rwqrIl3JS2vsnERKkaX39K",
  server: false

# In test we don't send emails.
config :mypcstmr, Mypcstmr.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
