defmodule TruffleHog.SparseVector do
  def empty_vector do
    %{}
  end

  def add_on(vector, position, value) do
    if value != 0 do
      vector |> Map.put(position, get_value(vector, position)+value)
    else
      vector
    end
  end

  def replace_on(vector, position, value) do
    vector |> Map.put(position, value)
  end

  def get_value(vector, position) do
    Map.get(vector, position, 0.0)
  end

  def dot_product(a, b) do
    a
    |> Enum.map(fn {index, value} -> value * get_value(b, index) end)
    |> Enum.sum
  end

  def vector_length(a) do
    dot_product(a, a)
    |> :math.sqrt()
  end

  def cosine(a, b) do
    if is_empty(a) || is_empty(b) do
      0
    else
      dot_product(a, b) / (vector_length(a)*vector_length(b))
    end
  end

  def is_empty(vector) do
    vector == %{}
  end
end
