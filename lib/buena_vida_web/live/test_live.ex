# lib/buena_vida_web/live/test_live.ex
defmodule BuenaVidaWeb.TestLive do
  use BuenaVidaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, message: "¡Hola desde TestLive!")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen justify-center items-center">
      <div class="text-center">
        <h1 class="text-3xl font-bold text-gray-800">Test LiveView</h1>
        <p class="mt-4 text-lg text-gray-600"><%= @message %></p>
      </div>
    </div>
    """
  end
end
