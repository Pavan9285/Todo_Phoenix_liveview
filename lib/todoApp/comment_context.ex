defmodule TodoApp.CommentContext do
  import Ecto.Query, warn: false
  alias TodoApp.Repo

  alias TodoApp.CommentContext.Comment

  def list_comments do
    Repo.all(Comment)
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:comment_created)
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
    |> broadcast(:comment_updated)
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
    |> broadcast(:comment_deleted)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def get_comments_by_todo_id(todo_id) do
    query = from Comment, where: [todo_id: ^todo_id]
    Repo.all(query)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(TodoApp.PubSub, "comments")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, comment}, event) do
    Phoenix.PubSub.broadcast(TodoApp.PubSub, "comments", {event, comment})
    {:ok, comment}
  end
end
