defmodule TodoAppWeb.TodoLive.Show do
  use TodoAppWeb, :live_view

  alias TodoApp.TodoContext
  alias TodoApp.CommentContext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo, TodoContext.get_todo!(id))
     |> assign(:comments, CommentContext.get_comments_by_todo_id(id))}
  end

  defp page_title(:show), do: "Show Todo"
  defp page_title(:edit), do: "Edit Todo"
end
