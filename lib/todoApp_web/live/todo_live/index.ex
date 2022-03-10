defmodule TodoAppWeb.TodoLive.Index do
  use TodoAppWeb, :live_view

  alias TodoApp.TodoContext
  alias TodoApp.TodoContext.Todo

  alias TodoApp.TodoContext

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    if(connected?(socket), do: TodoContext.subscribe())

    {:ok, assign(socket, :todos, list_of_todos_by_user_id(socket)),
     temporary_assigns: [todos: []]}
  end

  defp list_of_todos_by_user_id(socket) do
    TodoContext.todos_by_user(socket.assigns.current_user.id)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, TodoContext.get_todo!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = TodoContext.get_todo!(id)
    {:ok, _} = TodoContext.delete_todo(todo)

    {:noreply, assign(socket, :todos, list_todos())}
  end

  defp list_todos do
    TodoContext.list_todos()
  end

  @impl true
  def handle_info({:todo_created, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  def handle_info({:todo_updated, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  def handle_info({:todo_deleted, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> todo.id != todos.id end)}
  end

  # def handle_info({:todo_deleted, todo}, socket) do
  #   {:noreply, update(socket, :todos, list_todos())}
  # end
end
