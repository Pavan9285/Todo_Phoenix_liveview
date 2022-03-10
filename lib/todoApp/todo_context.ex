defmodule TodoApp.TodoContext do
  @moduledoc """
  The TodoContext context.
  """

  import Ecto.Query, warn: false
  alias TodoApp.Repo

  alias TodoApp.TodoContext.Todo

  def list_todos do
    Repo.all(Todo)
  end

  def get_todo!(id), do: Repo.get!(Todo, id)

  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.create_changeset(attrs)
    |> Repo.insert()
    |> broadcast(:todo_created)
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
    |> broadcast(:todo_updated)
  end

  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
    |> broadcast(:todo_deleted)
  end

  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  def todos_by_user(id) do
    # query = from "todos", where: [user_id: ^id],
    #     select: [:id, :title, :completed, :priority]

    query = from(t in Todo, where: [user_id: ^id], order_by: [desc: t.id])
    Repo.all(query)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(TodoApp.PubSub, "todos")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, todo}, event) do
    Phoenix.PubSub.broadcast(TodoApp.PubSub, "todos", {event, todo})
    {:ok, todo}
  end
end
