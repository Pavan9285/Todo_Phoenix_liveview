defmodule TodoApp.TodoContext.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.Accounts.User
  alias TodoApp.CommentContext.Comment

  schema "todos" do
    field :completed, :boolean, default: false
    field :priority, :string
    field :title, :string
    # field :user_id, :id
    belongs_to(:users, User, foreign_key: :user_id)
    has_many(:comments, Comment, foreign_key: :todo_id)
    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :completed, :priority])
    |> validate_required([:title, :completed, :priority])
  end

  def create_changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :completed, :priority, :user_id])
    |> validate_required([:title, :completed, :priority, :user_id])
  end
end
