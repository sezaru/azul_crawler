import Config

config :wallaby,
  chromedriver: [
    path: "./chromedriver",
    headless: false
  ]

config :wallaby,
  max_wait_time: 30_000,
  js_logger: nil,
  js_errors: false
