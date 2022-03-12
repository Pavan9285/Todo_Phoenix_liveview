defmodule TodoAppWeb.TodoLive.Show do
  use TodoAppWeb, :live_view

  alias TodoApp.TodoContext
  alias TodoApp.CommentContext

  @impl true
  def mount(_params, _session, socket) do
    if(connected?(socket), do: CommentContext.subscribe())
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

  @impl true
  def handle_event("delete-comment", %{"id" => id}, socket) do
    comment = CommentContext.get_comment!(id)
    {:ok, _} = CommentContext.delete_comment(comment)
    {:noreply, assign(socket, :comments, list_comments(comment.todo_id))}
  end

  defp list_comments(todo_id) do
    CommentContext.get_comments_by_todo_id(todo_id)
  end

  @impl true
  def handle_info({:comment_created, comment}, socket) do
    {:noreply, update(socket, :comments, fn comments -> [comment | comments] end)}
  end

  def handle_info({:comment_updated, comment}, socket) do
    {:noreply, update(socket, :comments, fn comments -> [comment | comments] end)}
  end

  def handle_info({:comment_deleted, comment}, socket) do
    {:noreply, update(socket, :comments, fn comments -> comment.id != comments.id end)}
  end
end
