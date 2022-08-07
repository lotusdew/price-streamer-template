defmodule Mypcstmr.Functions.Spread do
  alias Mypcstmr.Models.Spread

  def create_spread(operands, show_function, buy_action, is_future) do
    Memento.transaction( fn ->
      spread = %Spread{operands: operands, show_function: show_function,
                buy_action: buy_action, is_future: is_future}
      Memento.Query.write(spread)
    end)
  end

  def list_spreads() do
    Memento.transaction(fn ->
      Memento.Query.all(Spread)
    end)
  end

  def get_spread!(spread_id) do
    Memento.transaction!(fn ->
      Memento.Query.read(Spread, spread_id)
    end)
  end

  def delete_spread(spread_id) do
    Memento.transaction(fn ->
      Memento.Query.delete(Spread, spread_id)
    end)
  end
end
