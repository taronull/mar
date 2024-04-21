defprotocol Mar.Route do
  def before_action(route)
  def after_action(route)
end

defimpl Mar.Route, for: Any do
  def before_action(route), do: route
  def after_action(route), do: route
end
