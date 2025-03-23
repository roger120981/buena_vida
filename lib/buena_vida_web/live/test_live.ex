# lib/buena_vida_web/live/test_live.ex
defmodule BuenaVidaWeb.TestLive do
  use BuenaVidaWeb, :surface_live_view

  alias BuenaVidaWeb.TestCard

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :active_page, "test")
    {:ok, socket, layout: {BuenaVidaWeb.Layouts, :app}}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex min-h-screen justify-center items-center">

      <TestCard title="Test Card">
      <.react name="Simple" />
        This is a test to verify Surface is working correctly!
      </TestCard>
    </div>
    """
  end
end
