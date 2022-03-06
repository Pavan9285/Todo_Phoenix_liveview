defmodule TodoApp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :title, :string
      add :rating, :integer
      add :todo_id, references(:todos, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:todo_id])
  end
end
