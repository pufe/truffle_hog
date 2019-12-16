defmodule TruffleHogTest do
  use ExUnit.Case

  @document1 ~w(this is a a sample)
  @document2 ~w(another example this example is another example)
  @index TruffleHog.index_documents([{1, @document1}, {2, @document2}])

  test "index_documents has id of all documents" do
    assert [{1, alpha}, {2, beta}] = @index.indices
  end

  test "find_matches returns the correct document on exact match" do
    assert [{1, alpha}] = TruffleHog.find_matches(@index, @document1, 1)
    assert 1 - alpha < 0.0001
  end

  test "find_matches does not break if quantity is greater than total" do
    assert [{2, beta}, {1, alpha}] = TruffleHog.find_matches(@index, ~w(example), 5)
  end

  test "find_matches does not break if search has different words" do
    assert [{1, alpha}, {2, beta}] = TruffleHog.find_matches(@index, ~w(foo bar), 2)
  end

  test "find_matches returns first the document containing the word" do
    assert [{2, beta}, {1, alpha}] = TruffleHog.find_matches(@index, ~w(example), 2)
  end
end
