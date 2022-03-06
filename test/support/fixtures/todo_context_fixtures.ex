defmodule TodoApp.TodoContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApp.TodoContext` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        completed: true,
        priority: "some priority",
        title: "some title"
      })
      |> TodoApp.TodoContext.create_todo()

    todo
  end
end
