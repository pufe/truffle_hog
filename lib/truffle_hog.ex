defmodule TruffleHog do
  alias TruffleHog.{SparseVector, WordBag}

  @moduledoc """
  Provides a method to search for matches within a list of documents using TF-IDF.

  There are two main use cases: finding which documents are the most similar within
  the list; finding which document is the most related to a search query.

  ## How to use

  Convert each document into a tuple where the first item is an identifier, and the
  second is a list of tokens. Tokenizer is not included, because you may want to write
  your own.

  Example:

      [{1, ~w(this is a a sample)},
       {2, ~w(this example is another example)}]

  Create an _index_ using the function `index_documents`.

      index = list_documents |> TruffleHog.index_documents()

  Use `find_matches` to find the matches on the index.

      matches = index |> TruffleHog.find_matches(["search", "items"], quantity)
  """

  @doc """
  Indexes a list of documents.

  Returns a map with all the indices to make future searches.

  _documents_ is expected to be a list of pairs, the first being the id
  of the document, and the second a list of tokens contained in the document.

  ## Example argument

      [{1, ~w(this is a a sample)},
       {2, ~w(this example is another example)}]
  """
  def index_documents(documents) do
    bag = add_all_documents(documents, WordBag.empty_bag())
    indices = setup_indices(documents, bag)
    %{
      bag: bag,
      indices: indices
    }
  end

  defp add_all_documents([{_id, tokens} | rest], bag) do
    add_all_documents(rest, WordBag.add_document(bag, tokens))
  end

  defp add_all_documents([], bag) do
    bag
  end

  defp setup_indices(documents, bag) do
    documents
    |> Enum.map(fn {id, tokens} ->
      {id, WordBag.tf_idf(bag, tokens)}
    end)
  end

  @doc """
  Finds the best matches within the index.

  _index_ must be the return of TruffleHog.index_documents.

  _search_ is a list of tokens to search for.

  _quantity_ is the number of matches to be returned.

  Returns a list of tuples, where the first item of the tuple
  is the identifier of the document, and the second is a factor
  of how similar the document is to the search. The list is sorted
  from most similar to least similar.
  """
  def find_matches(_index = %{bag: bag, indices: indices}, search, quantity) do
    target = WordBag.tf_idf(bag, search)
    indices
    |> Enum.map(fn {id, vector} ->
      {id, SparseVector.cosine(target, vector)}
    end)
    |> Enum.sort_by(fn {_id, cosine} ->
      1 - cosine
    end)
    |> Enum.take(quantity)
  end
end
