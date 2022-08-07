defmodule MypcstmrWeb.LoginController do
  use MypcstmrWeb, :controller
  plug :prevent_unauthorized_access when action in [:home]

  alias Mypcstmr.Functions.Users
  alias Mypcstmr.Models.User
  import Mypcstmr.Mnesia

  def test(conn, _) do
    # Mypcstmr.Mnesia.setup!(Mypcstmr.Models.User)
    Users.create_dummy_user()
    render(conn, "index.html")
  end

  def show(conn, %{"uid" => uid}) do
    user_id = Memento.transaction!(fn ->
      Memento.Query.read(User, :uid)
    end)
    render(conn, "index.html", user_id: user_id)
  end

  def login(conn, %{"phone_no" => phone_no}) do
    # %{"phone_no" => phone_no} = phone_no
    # IO.inspect("phone_no=====>",phone_no)
      # IO.inspect("dummyUser=====>",user)
    # IO.inspect(Memento.transaction!(fn ->
    #     Memento.Query.read(User, 1)
    #     end))
    if true do
      render(conn, "new.html")
    else
      render(conn, "new.html")
    # user = Memento.transaction!(fn ->
    #   Memento.Query.select(User, {:==, :phone_no, Integer.parse(phone_no) |> elem(0)})
    # end)
    # case user do
    #   user = [%User{}] ->
    #     [user_one] = user
    #     uname = user_one.username
    #     otp = user_one.otp
    #     if otp == nil do
    #       api_exotel_key = System.get_env("API_EXOTEL_KEY")
    #       api_exotel_token = System.get_env("API_EXOTEL_TOKEN")
    #       api_exotel_subdomain = System.get_env("API_EXOTEL_SUBDOMAIN")
    #       api_exotel_sid = System.get_env("API_EXOTEL_SID")
    #       api_exotel_entid = System.get_env("API_EXOTEL_ENTID")
    #       api_exotel_tmpltid = System.get_env("API_EXOTEL_TMPLTID")

    #       phone_otp = generate_otp()

    #       sms_url = "https://#{api_exotel_key}:#{api_exotel_token}@#{api_exotel_subdomain}/v1/Accounts/#{api_exotel_sid}/Sms/send.json"

    #       msg_body = "OTP for KYC chat on LOTUSDEW is #{phone_otp} and valid till 30 mins. Do not share OTP with anyone for security reasons."

    #       sms_body = Poison.encode!(%{From: "LOTUSD", To: phone_no, Body: msg_body,
    #                     DltTemplateId: api_exotel_tmpltid, DltEntityId: api_exotel_entid})

    #       # sms2 = Poison.encode!(%{body: "balle balle"})

    #       IO.puts(sms_body)
    #       resp = HTTPoison.post(sms_url, sms_body)

    #       case resp do
    #         {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    #           response = Poison.decode!(body)
    #           Users.update_user(uname, %{otp: phone_otp})
    #           put_status(conn, 200) |> json(%{message: "Namaskar #{uname}, check your phone no: #{phone_no} for OTP: #{phone_otp}.\n SMS body: #{response}.\n"})
    #         {:ok, %HTTPoison.Response{status_code: 404}} ->
    #           put_status(conn, 500) |> json(%{message: "SMS Auth failed with 404"})
    #         {:error, %HTTPoison.Error{reason: reason}} ->
    #           put_status(conn, 500) |> json(%{message: "SMS Auth failed with reason: #{reason}"})
    #       end
    #     else
    #       put_status(conn, 200) |> json(%{success: true, message: "Namaskar #{uname}, logging as dev user"})
    #       render(conn,"new.html")
    #     end
    #   _ ->
    #   put_status(conn, 401) |> json(%{message: "Unauthorized Phone No"})
    #   render(conn,"new.html")

    end
  end

  def generate_otp() do
    "PS_TOTP_KEY"
    |> System.get_env
    |> Base.decode32!
    |> NimbleTOTP.verification_code
  end




  def verify_otp(conn,%{"otp" => otp} ) do
  # %{"phone_no" => phone_no, "otp" => otp}
    user = Memento.transaction!(fn ->
      Memento.Query.select(User, {:==, :phone_no, 1234567899})
    end)
    case user do
        user = [%User{}] ->
          [user_one] = user
          uname = user_one.username
          phone_otp = user_one.otp
          entered_otp = otp
          IO.inspect("entered_otp =====>",entered_otp)
          if phone_otp == entered_otp do
            IO.inspect("I am in if")
            render(conn, "home.html")

          else
            IO.inspect("I am in else")
            render(conn, "new.html")
          end
    end




    # render(conn, "home.html")
    # user = Memento.transaction!(fn ->
    #   Memento.Query.select(User, {:==, :phone_no, Integer.parse(phone_no) |> elem(0)})
    # end)
    # case user do
    #   user = [%User{}] ->
    #     [user_one] = user
    #     uname = user_one.username
    #     phone_otp = user_one.otp
    #     entered_otp = Integer.parse(otp) |> elem(0)
    #     if phone_otp == entered_otp do
    #       put_status(conn, 200) |> json(%{success: true, message: "Namaskar #{uname}, verified user",
    #         spreads: [1], is_admin: user_one.is_admin, user_id: uname, token: "anytokenfortesting"
    #         # |> put_session(:phone_no, user_one.phone_no)
    #         # |> configure_session(renew: true)
    #       })
    #     |> redirect(to: "/home")

    #     else
    #       IO.inspect({phone_otp, entered_otp})
    #       put_status(conn, 401) |> json(%{success: false, message: "OTP verification failed, OTPs do not match"})
    #     end
    #   _ ->
    #   put_status(conn, 401) |> json(%{success: false, message: "Unauthorized Phone no"})
    #   # |> redirect(to: Routes.session_path(conn, :new))
    # end
  end

  defp prevent_unauthorized_access(conn, _opts) do
    current_user = Map.get(conn.assigns, :current_user)

   requested_user_id =
         Memento.transaction(fn ->
      Memento.Query.read(User, :phone_no)
    end)

    if current_user == nil || current_user.phone_no != requested_user_id do
      conn
      |> put_flash(:error, "Niice try, friend. that's not a page for you")
      |> redirect(to: Routes.login_path(conn, :test))
      |> halt()

    else
      conn
    end

  end
end
