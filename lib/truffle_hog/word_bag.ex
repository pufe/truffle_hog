defmodule TruffleHog.WordBag do
  alias TruffleHog.SparseVector

  def empty_bag do
    %{
      words: %{},
      documents: 0,
    }
  end

  def size(_bag = %{words: _words, documents: documents}) do
    documents
  end

  def add_document(_bag = %{words: words, documents: documents}, document) do
    %{
      words: merge_words(words, document),
      documents: documents+1
    }
  end

  def merge_words(words, document) do
    document
    |> Enum.uniq()
    |> Enum.reduce(words, fn word, words -> add_word(words, word) end)
  end

  def add_word(words, word) do
    Map.merge(words, %{word => 1}, fn _key, v1, v2 -> v1+v2 end)
  end

  def find_occurrences(words, word) do
    Map.get(words, word, 0.0)
  end

  def idf(_bag = %{words: words, documents: documents}, word) do
    n = find_occurrences(words, word)
    if n > 0 do
      :math.log10(documents/n)
    else
      0
    end
  end

  def tf_idf(bag, document) do
    size = Enum.count(document)
    document
    |> Enum.reduce(SparseVector.empty_vector, fn word, vector ->
      SparseVector.add_on(vector, word, idf(bag, word)/size)
    end)
  end
end
