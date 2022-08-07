defmodule Mypcstmr.Models.User do
  use Memento.Table,
    attributes: [:uid, :username, :phone_no, :otp, :is_admin, :backend]
end


