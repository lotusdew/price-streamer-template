defmodule Mypcstmr.Functions.Users do
  alias Mypcstmr.Models.User

  def list_users() do
    Memento.transaction(fn ->
      Memento.Query.all(User)
    end)
  end

  def get_user!(uid) do
    Memento.transaction!(fn ->
      Memento.Query.read(User, uid)
    end)
  end

  @spec delete_user(any) :: any
  def delete_user(uid) do
    Memento.transaction!(fn ->
      Memento.Query.delete(User, uid)
    end)
  end

  def create_dummy_user() do
    IO.inspect("create_dummy_user called")
    user = %User{uid: 1, username: "test", phone_no: 1234567899, otp: 123, is_admin: false, backend: ""}
    Memento.transaction!(fn ->
      Memento.Query.write(user)
    end)
  end

  # don't know what this does, the first clause in switch case
  def create_user(uid,username, phone_no, otp, is_admin, backend) do
    case get_user!(username) do
      [%User{} = user] -> {:ok, user}
      _ ->
        user = %User{uid: uid, username: username, phone_no: phone_no, otp: otp, is_admin: is_admin, backend: backend}
        Memento.transaction!(fn ->
          Memento.Query.write(user)
        end)
    end
  end

  def update_user(username, %{} = changes) do
    Memento.transaction!(fn ->
      case Memento.Query.read(User, username, lock: :write) do
        %User{} = user ->
          user
          |> struct(changes)
          |> Memento.Query.write()
          |> then(&{:ok, &1})

        nil ->
          {:error, :not_found}
      end
    end)
  end

end
