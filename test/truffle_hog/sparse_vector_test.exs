defmodule TruffleHog.SparseVectorTest do
  alias TruffleHog.SparseVector
  use ExUnit.Case
  doctest SparseVector

  test "length of empty vector" do
    assert SparseVector.vector_length(SparseVector.empty_vector) == 0
  end

  test "length of non-empty vector" do
    vector = SparseVector.empty_vector
    |> SparseVector.replace_on(0, 3)
    |> SparseVector.replace_on(1, 4)

    assert SparseVector.vector_length(vector) == 5
  end

  test "cosine of empty vector" do
    vector_a = SparseVector.empty_vector
    |> SparseVector.replace_on(0, 3)
    |> SparseVector.replace_on(1, 4)

    vector_b = SparseVector.empty_vector

    assert SparseVector.cosine(vector_a, vector_b) == 0
  end

  test "cosine of orthogonal vectors" do
    vector_a = SparseVector.empty_vector
    |> SparseVector.replace_on("bola", 1)

    vector_b = SparseVector.empty_vector
    |> SparseVector.replace_on("batata", 3)

    assert SparseVector.cosine(vector_a, vector_b) == 0
  end

  test "cosine of equal vectors" do
    vector_a = SparseVector.empty_vector
    |> SparseVector.replace_on("bola", 3)
    |> SparseVector.replace_on("batata", 4)

    assert SparseVector.cosine(vector_a, vector_a) == 1
  end

  test "cosine 45 degrees" do
    vector_a = SparseVector.empty_vector
    |> SparseVector.replace_on("bola", 4)
    |> SparseVector.replace_on("batata", 4)

    vector_b = SparseVector.empty_vector
    |> SparseVector.replace_on("batata", 4)

    calculated = SparseVector.cosine(vector_a, vector_b)
    expected = :math.cos(:math.pi/4)
    error = abs(calculated - expected)
    assert error <= 1.0e-6
  end
end
