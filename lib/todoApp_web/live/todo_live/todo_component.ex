defmodule TodoAppWeb.TodoLive.TodoComponent do
  use TodoAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <tr id={"todo-#{@todo.id}"}>
        <td><%= @todo.title %></td>
        <td><%= @todo.completed %></td>
        <td><%= @todo.priority %></td>
        <td>
          <%= live_redirect to: Routes.todo_show_path(@socket, :show, @todo) do %>
            <span style="font-size:20px">&#83;&#104;&#111;&#119;</span>
          <% end %> &nbsp;&nbsp;&nbsp;
          <%= live_patch to: Routes.todo_index_path(@socket, :edit, @todo.id) do %>
            <span style="font-size:20px">&#69;&#100;&#105;&#116;</span>
          <% end %> &nbsp;&nbsp;&nbsp;
          <%= link to: "#", phx_click: "delete", phx_value_id: @todo.id, data: [confirm: "Are you sure?"] do %>
            <span style="font-size:20px"> 🚮 </span>
          <% end %>
        </td>
      </tr>
    """
  end
end
