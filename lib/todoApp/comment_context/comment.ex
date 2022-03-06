defmodule TodoApp.CommentContext.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.TodoContext.Todo

  schema "comments" do
    field :rating, :integer
    field :title, :string
    # field :todo_id, :id
    belongs_to(:todos, Todo, foreign_key: :todo_id)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:title, :rating])
    |> validate_required([:title, :rating])
  end
end
