defmodule MypcstmrWeb.PageController do
  use MypcstmrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
