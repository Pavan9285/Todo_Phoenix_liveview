defmodule TodoAppWeb.TodoLive.CommentComponent do
  use TodoAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <tr id={"comment-#{@comment.id}"}>
    <td><%= @comment.title %></td>
    <td><%= @comment.rating %></td>
    <td>
      <%= live_redirect to: Routes.comment_show_path(@socket, :show, @comment) do %>
        <span style="font-size:20px">&#83;&#104;&#111;&#119;</span>
      <% end %> &nbsp;&nbsp;&nbsp;
      <%= live_patch to: Routes.comment_index_path(@socket, :edit, @comment.id) do %>
        <span style="font-size:20px">&#69;&#100;&#105;&#116;</span>
      <% end %> &nbsp;&nbsp;&nbsp;
      <%= link to: "#", phx_click: "delete-comment", phx_value_id: @comment.id, data: [confirm: "Are you sure?"] do %>
        <span style="font-size:20px"> 🚮 </span>
      <% end %>
    </td>
    </tr>
    """
  end
end
