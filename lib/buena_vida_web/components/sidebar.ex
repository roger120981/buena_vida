# lib/buena_vida_web/components/sidebar.ex
defmodule BuenaVidaWeb.Components.Sidebar do
  @moduledoc """
  A sidebar component for navigation in Adult Health Care Day, styled with the Xintra template.
  Provides a responsive sidebar that can be toggled on mobile and expands on hover on desktop.
  """
  use Surface.LiveComponent

  @doc "The active page to highlight in the sidebar"
  prop active_page, :string, default: "dashboard"

  @doc "Whether the sidebar is open on mobile"
  data sidebar_open, :boolean, default: false

  def render(assigns) do
    ~F"""
    <div>
      <div class={[
        "fixed inset-y-0 left-0 z-50 w-64 bg-gradient-to-b from-blue-900 to-blue-800 text-white shadow-2xl transform transition-transform duration-300 ease-in-out",
        @sidebar_open && "translate-x-0",
        !@sidebar_open && "-translate-x-full",
        "md:w-20 md:translate-x-0 md:hover:w-64 md:hover:shadow-3xl group"
      ]}>
        <!-- Header del Sidebar -->
        <div class="flex items-center justify-between p-4 border-b border-blue-700">
          <span class="text-xl font-extrabold text-white tracking-wide md:hidden md:group-hover:block">
            BuenaVida
          </span>
          <button
            class="md:hidden text-blue-300 hover:text-white"
            :on-click="toggle"
            aria-label={if @sidebar_open, do: "Close sidebar", else: "Open sidebar"}
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Navegación -->
        <nav class="mt-6 space-y-1">
          <.link
            patch="/dashboard"
            class={[
              "flex items-center px-4 py-3 text-blue-100 hover:bg-blue-700 hover:text-white transition-colors duration-200",
              @active_page == "dashboard" && "bg-blue-700 text-white"
            ]}
          >
            <i class="hero-home w-6 h-6 md:mx-auto md:group-hover:mx-0 md:group-hover:mr-3"></i>
            <span class="md:hidden md:group-hover:block">Dashboard</span>
          </.link>

          <.link
            patch="/participants"
            class={[
              "flex items-center px-4 py-3 text-blue-100 hover:bg-blue-700 hover:text-white transition-colors duration-200",
              @active_page == "participants" && "bg-blue-700 text-white"
            ]}
          >
            <i class="hero-user w-6 h-6 md:mx-auto md:group-hover:mx-0 md:group-hover:mr-3"></i>
            <span class="md:hidden md:group-hover:block">Participants</span>
          </.link>

          <.link
            patch="/case-managers"
            class={[
              "flex items-center px-4 py-3 text-blue-100 hover:bg-blue-700 hover:text-white transition-colors duration-200",
              @active_page == "case-managers" && "bg-blue-700 text-white"
            ]}
          >
            <i class="hero-user-circle w-6 h-6 md:mx-auto md:group-hover:mx-0 md:group-hover:mr-3"></i>
            <span class="md:hidden md:group-hover:block">Case Managers</span>
          </.link>

          <.link
            patch="/caregivers"
            class={[
              "flex items-center px-4 py-3 text-blue-100 hover:bg-blue-700 hover:text-white transition-colors duration-200",
              @active_page == "caregivers" && "bg-blue-700 text-white"
            ]}
          >
            <i class="hero-user-group w-6 h-6 md:mx-auto md:group-hover:mx-0 md:group-hover:mr-3"></i>
            <span class="md:hidden md:group-hover:block">Caregivers</span>
          </.link>

          <.link
            patch="/agencies"
            class={[
              "flex items-center px-4 py-3 text-blue-100 hover:bg-blue-700 hover:text-white transition-colors duration-200",
              @active_page == "agencies" && "bg-blue-700 text-white"
            ]}
          >
            <i class="hero-building-office w-6 h-6 md:mx-auto md:group-hover:mx-0 md:group-hover:mr-3"></i>
            <span class="md:hidden md:group-hover:block">Agencies</span>
          </.link>
        </nav>
      </div>

      {#if @sidebar_open}
        <div class="fixed inset-0 bg-black opacity-50 md:hidden" :on-click="toggle" />
      {/if}
    </div>
    """
  end

  @impl true
  def handle_event("toggle", _, socket) do
    {:noreply, update(socket, :sidebar_open, &(!&1))}
  end
end
