defmodule TodoApp.CommentContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApp.CommentContext` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        rating: 42,
        title: "some title"
      })
      |> TodoApp.CommentContext.create_comment()

    comment
  end
end
