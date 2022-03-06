defmodule TodoApp.TodoContextTest do
  use TodoApp.DataCase

  alias TodoApp.TodoContext

  describe "todos" do
    alias TodoApp.TodoContext.Todo

    import TodoApp.TodoContextFixtures

    @invalid_attrs %{completed: nil, priority: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert TodoContext.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert TodoContext.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{completed: true, priority: "some priority", title: "some title"}

      assert {:ok, %Todo{} = todo} = TodoContext.create_todo(valid_attrs)
      assert todo.completed == true
      assert todo.priority == "some priority"
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TodoContext.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{completed: false, priority: "some updated priority", title: "some updated title"}

      assert {:ok, %Todo{} = todo} = TodoContext.update_todo(todo, update_attrs)
      assert todo.completed == false
      assert todo.priority == "some updated priority"
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = TodoContext.update_todo(todo, @invalid_attrs)
      assert todo == TodoContext.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = TodoContext.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> TodoContext.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = TodoContext.change_todo(todo)
    end
  end
end
