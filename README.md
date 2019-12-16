# TruffleHog

Provides a method to search for matches within a list of documents using TF-IDF.

There are two main use cases: finding which documents are the most similar within
the list; finding which document is the most related to a search query.

## How to use

Convert each document into a tuple where the first item is an identifier, and the
second is a list of tokens. Tokenizer is not included, because you may want to write
your own.

Example of document_list:

```elixir
[{1, ~w(this is a a sample)},
 {2, ~w(this example is another example)}]
```

Create an _index_ using the function `index_documents`.

```elixir
index = list_documents |> TruffleHog.index_documents()
```

Use `find_matches` to find the matches on the index.

```elixir
matches = index |> TruffleHog.find_matches(["search", "items"], quantity)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `truffle_hog` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:truffle_hog, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/truffle_hog](https://hexdocs.pm/truffle_hog).

