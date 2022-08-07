defmodule MypcstmrWeb.HomeLive do
  use MypcstmrWeb, :live_view


  def mount(_params, _session, socket) do
    socket = assign(socket, :text, "I am in Mount")
    {:ok, socket}
  end

# Volunteers -> Price  Volunteer -> User  volunteers -> users
  def render(assigns) do
    ~L"""
    <div class="mainContainer">
      <section class="topSection">
        <div class="dropdownSection">
        <div class="spreadContainer">
          <div>
            <span>Spread Type</span>
          </div>
          <div>
            <span>spread ID</span>
          </div>
        </div>
         <div class="dropdown">
          <button
            type="button"
            class="sprdButton"
          >
            Select Spread
          </button>
        </div>
        </div>
       <section class="pnlSection">
        <div class="headSection">
          <div class="cardsContainer">
            <div class="upperCard">
                <div class="card">Executed Level :</div>
                <div class="cardValue">
                  <%# avgSpread[spreadId] || "-" %>
                </div>
              </div>
              <div class="upperCard">
                <div class="cardTitle">Total Realised PNL :</div>
                <div class="cardValue">
                  <%# round(TotalRealizedPnl, 2) || "-"" %>
                </div>
              </div>
              <div class="upperCard">
                <div class="cardTitle">Realised PNL </div>
                <div class="cardValue">
                  <%# "round(realizedPnl, 2) || "-"" %>
                </div>
              </div>
              <div class="upperCard">
                <div class="cardTitle">Total Daily PNL :</div>
                <div class="cardValue">
                  <%# "round(TotalDailyPnl, 2) || "-"" %>
                </div>
              </div>
              <div class="upperCard">
                <div class="cardTitle">Daily PNL </div>
                <div class="cardValue">
                  <%# "round(dailyPnl, 2) || "-"" %>
                </div>
              </div>
              <div class="upperCard">
                <div class="cardTitle">Net Positions :</div>
                <div class="cardValue">
                <%# "netPositions[spreadId] || "-"" %>
                </div>
              </div>

              <div class="upperCard">
                <div class="cardTitle">Total Un Realised PNL :</div>
                <div class="cardValue">
                  <%# "round(TotalUnRealizedPnl, 2) || "-"" %>
                </div>
              </div>
              <div class="upperCard">
                <div class="cardTitle">Un Realised PNL </div>
                <div class="cardValue">
                  <%# "round(unRealizedPnl, 2) || "-"" %>
                </div>
              </div>
          </div>
        </div>
      </section>
      </section>
      <section>
      <div class="LevelContainer">
          <div class="Level">
          <div class="heading">
            Level :
            </div>
            <div class="levelValue">
            <%# level?.toFixed(2)" %>
            </div>
        </div>

        </div>
      </section>
      <section class="contentSection">
      <div class="TableSection">
        <table>
        <thead>
          <tr>
            <th>Action</th>
            <th>Value</th>
            <th>Timestamp</th>
          </tr>
        </thead>
        <tbody>
            <tr>
                <td>BOT : SOLD</td>
                <td>spread value</td>
                <td>time</td>
            </tr>
        </tbody>
      </table>
      </div>
      <div>
        Chart
      <div>
    </section>
    <section>
    <div class="btn-container">
    <%= @text %>
        <button phx-click="sell">
          Sell
        </button>
        <button phx-click="buy">
          Buy
        </button>
      </div>
    </section>
  </div>
    """
  end

  def handle_event("sell", _, socket) do
    socket = assign(socket, :text, "Sell called")
  {:noreply, socket}
  end

  def handle_event("buy", _, socket) do
    socket = assign(socket, :text, "Buy Called")
    {:noreply, socket}
  end

end
