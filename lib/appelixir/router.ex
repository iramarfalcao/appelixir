defmodule Appelixir.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    response = "<h1>AppElixir</h1>"

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, response)
  end

  get "/get" do
    values = Cache.get()

    response =
      %{time: DateTime.utc_now()}
      |> Map.merge(values)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  put "/put" do
    %{"key" => key, "value" => value} = URI.decode_query(conn.query_string)

    Cache.put(key, value)
    values = Cache.get()

    response =
      %{time: DateTime.utc_now()}
      |> Map.merge(values)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
