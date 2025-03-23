defmodule BuenaVidaWeb.Router do
  use BuenaVidaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BuenaVidaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BuenaVidaWeb do
    pipe_through :browser

    live "/dashboard", DashboardLive, :index
    live "/participants", ParticipantsLive, :index
    live "/case-managers", CaseManagersLive, :index
    live "/caregivers", CaregiversLive, :index
    live "/agencies", AgenciesLive, :index
    live "/test", TestLive, :index # Mantengo esta para tu prueba
  end

  # Other scopes may use custom stacks.
  # scope "/api", BuenaVidaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:buena_vida, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BuenaVidaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
