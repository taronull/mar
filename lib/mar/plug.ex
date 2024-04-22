defmodule Mar.Plug do
  @moduledoc false

  use Plug.Builder

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    json_decoder: Jason
  )

  plug(Mar.Router)
end
