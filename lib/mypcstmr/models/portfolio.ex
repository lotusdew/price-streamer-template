defmodule Mypcstmr.Models.Portfolio do
  use Memento.Table,
    attributes: [:id, :user, :ticker, :units, :rate, :real_pnl, :daily_pnl, :spread_id]
end
