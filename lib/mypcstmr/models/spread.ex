defmodule Mypcstmr.Models.Spread do
  use Memento.Table,
    attributes: [:id, :operands, :show_function, :buy_action, :is_future],
    type: :ordered_set,
    autoincrement: true
end
