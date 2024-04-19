defprotocol Mar.Route do
  @fallback_to_any true
  def path(struct)
end

defimpl Mar.Route, for: Any do
  def path(_), do: "/"
end
