defmodule Mar.Plug do
  use Plug.Builder

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    json_decoder: Jason
  )

  plug(Mar.Router)
end
