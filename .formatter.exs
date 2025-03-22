[
  import_deps: [:ash_postgres, :ash, :ecto, :ecto_sql, :phoenix, :surface],
  subdirectories: ["priv/*/migrations"],
  plugins: [Spark.Formatter, Phoenix.LiveView.HTMLFormatter, Surface.Formatter.Plugin],
  inputs: [
  "*.{heex,ex,exs}",
  "{config,lib,test}/**/*.{heex,ex,exs}",
  "priv/*/seeds.exs",
  "{lib,test}/**/*.sface"
]
]
