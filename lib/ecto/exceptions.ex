alias Ecto.Query.Util

defexception Ecto.QueryError, [:reason, :type, :query, :file, :line] do
  def message(Ecto.QueryError[] = e) do
    if e.type && e.query && e.file && e.line do
      fl = Exception.format_file_line(e.file, e.line)
      "#{fl}: the query `#{e.type}: #{Macro.to_string(e.query)}` " <>
      "is invalid: #{e.reason}"
    else
      e.reason
    end
  end
end

defexception Ecto.InvalidURL, [:url, :reason] do
  def message(Ecto.InvalidURL[url: url, reason: reason]) do
    "invalid url #{url}: #{reason}"
  end
end

defexception Ecto.NoPrimaryKey, [:model] do
  def message(Ecto.NoPrimaryKey[model: model]) do
    "model `#{model.__struct__}` has no primary key"
  end
end

defexception Ecto.InvalidModel, [:model, :field, :type, :expected_type, :reason] do
  def message(Ecto.InvalidModel[] = e) do
    expected_type = Util.type_to_ast(e.expected_type) |> Macro.to_string
    type = Util.type_to_ast(e.type) |> Macro.to_string
    "model #{inspect e.model} failed validation when #{e.reason}, " <>
    "field #{e.field} had type #{type} but type #{expected_type} was expected"
  end
end

defexception Ecto.NotSingleResult, [:model, :primary_key, :id] do
  def message(Ecto.NotSingleResult[] = e) do
    "the result set from `#{e.model}` where `#{e.primary_key} == #{e.id}` " <>
    "was not a single value"
  end
end

defexception Ecto.Query.TypeCheckError, [:expr, :types, :allowed] do
  @moduledoc """
  Exception raised when a query does not type check.
  Read `Ecto.Query` and `Ecto.Query.API` docs for more information.
  """
  def message(Ecto.Query.TypeCheckError[] = e) do
    {name, _, _} = e.expr
    expected = Enum.map_join(e.allowed, "\n    ", &Macro.to_string(&1))

    types  = Enum.map(e.types, &Util.type_to_ast/1)
    actual = Macro.to_string({name, [], types})

    """
    the following expression does not type check:

        #{Macro.to_string(e.expr)}

    Allowed types for #{name}/#{length(e.types)}:

        #{expected}

    Got: #{actual}
    """
  end
end

defexception Ecto.AssociationNotLoadedError, [:type, :name, :owner] do
  def message(Ecto.AssociationNotLoadedError[] = e) do
    "the #{e.type} association on #{e.owner}.#{e.name} was not loaded"
  end
end

defexception Ecto.MigrationError, [:message]
