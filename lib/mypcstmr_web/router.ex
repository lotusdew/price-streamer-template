defmodule MypcstmrWeb.Router do
  use MypcstmrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MypcstmrWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MypcstmrWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/new", LoginController, :test
    post "/login", LoginController, :login
    # get "/home", HomeController, :index

    # resources "/sessions", SessionController, only: [:new, :create, :delete],
    #                           singleton: true
    post "/verify_otp", LoginController, :verify_otp


  end

  scope "/", MypcstmrWeb do
    pipe_through :browser
    # pipe_through [:browser, :prevent_unauthorized_access]
    live "/home", HomeLive
    # get "/home", HomeController, :index
  end

  # defp authenticate_user(conn, _) do
  #   case get_session(conn, :user_id) do
  #     nil ->
  #       conn
  #       |> Phoenix.Controller.put_flash(:error,"Login Required")
  #       |> Phoenix.Controller.redirect(to: "/login")
  #       |> halt()
  #     user_id ->
  #       assign(conn, :current_user, Mypcstmr.Functions.Users.get_user!(user_id))
  #   end
  # end

  defp prevent_unauthorized_access(conn, _opts) do
    current_user = Map.get(conn.assigns, :current_user)

   requested_user_id =
         Memento.transaction(fn ->
      Memento.Query.read(User, :phone_no)
    end)

    if current_user == nil || current_user.phone_no != requested_user_id do
      conn
      |> put_flash(:error, "Niice try, friend. that's not a page for you")
      |> halt()

    else
      conn
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", MypcstmrWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MypcstmrWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
