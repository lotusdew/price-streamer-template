defmodule Mypcstmr.Models.Association do
  use Memento.Table,
    attributes: [:id, :user, :spread_id, :spread_offset, :net_position],
    type: :ordered_set,
    autoincrement: true
end
