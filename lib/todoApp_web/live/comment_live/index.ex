defmodule TodoAppWeb.CommentLive.Index do
  use TodoAppWeb, :live_view

  alias TodoApp.CommentContext
  alias TodoApp.CommentContext.Comment
  alias TodoApp.TodoContext

  @impl true
  def mount(_params, _session, socket) do
    if(connected?(socket), do: CommentContext.subscribe())
    {:ok, assign(socket, :comments, list_comments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Comment")
    |> assign(:comment, CommentContext.get_comment!(id))
  end

  # Passes the todo_id using params....
  defp apply_action(socket, :new, params) do
    socket
    |> assign(:page_title, "New Comment")
    |> assign(:todo_id, String.to_integer(params["todo_id"]))
    |> assign(:todo, TodoContext.get_todo!(String.to_integer(params["todo_id"])))
    |> assign(:comment, %Comment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Comments")
    |> assign(:comment, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comment = CommentContext.get_comment!(id)
    {:ok, _} = CommentContext.delete_comment(comment)

    {:noreply, assign(socket, :comments, list_comments())}
  end

  defp list_comments do
    CommentContext.list_comments()
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

  # def handle_info({:comment_deleted, comment}, socket) do
  #   {:noreply, update(socket, :comments, list_comments())}
  # end
end
