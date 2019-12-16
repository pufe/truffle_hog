defmodule TruffleHog.WordBagTest do
  alias TruffleHog.WordBag
  use ExUnit.Case

  @document1 ~w(this is a a sample)
  @document2 ~w(another example this example is another example)
  @example_bag WordBag.empty_bag
  |> WordBag.add_document(@document1)
  |> WordBag.add_document(@document2)

  # document1 = ~w(this is a a sample)
  # document2 = ~w(another example this example is another example)
  # example_bag = TruffleHog.WordBag.empty_bag |> TruffleHog.WordBag.add_document(document1) |> TruffleHog.WordBag.add_document(document2)

  test "empty_bag is empty" do
    empty_bag = WordBag.empty_bag
    assert WordBag.size(empty_bag) == 0
  end

  test "add_document increments document count" do
    assert WordBag.size(@example_bag) == 2
  end

  test "add_document adds all words" do
    (@document1 ++ @document2)
    |> Enum.each(fn word ->
      assert WordBag.find_occurrences(@example_bag.words, word) > 0
    end)
  end

  test "idf returns 0 when word is not found" do
    assert WordBag.idf(@example_bag, "zero") == 0
  end

  test "idf returns greater values for words in fewer documents" do
    assert WordBag.idf(@example_bag, "this") < WordBag.idf(@example_bag, "a")
  end

  test "idf returns the same value for words that occur in the same number of documents" do
    assert WordBag.idf(@example_bag, "sample") == WordBag.idf(@example_bag, "example")
    assert WordBag.idf(@example_bag, "this") == WordBag.idf(@example_bag, "is")
  end

  test "idf calculates the example on wikipedia" do
    value = WordBag.idf(@example_bag, "example")
    wikipedia = 0.301
    error = abs(value - wikipedia)

    assert error < 0.001
  end

  test "tf_idf calculates the example on wikipedia" do
    value = WordBag.tf_idf(@example_bag, @document2)
    |> TruffleHog.SparseVector.get_value("example")
    wikipedia = 0.129
    error = abs(value - wikipedia)

    assert error < 0.001
  end
end
