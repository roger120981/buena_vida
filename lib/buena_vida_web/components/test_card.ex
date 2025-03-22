# lib/buena_vida_web/components/test_card.ex
defmodule BuenaVidaWeb.TestCard do
  @moduledoc """
  A simple test component to verify Surface is working.
  """
  use Surface.Component

  @doc "The title of the card"
  prop title, :string, required: true

  @doc "The main content slot"
  slot default

  def render(assigns) do
    ~F"""
    <style>
      .card {
        @apply bg-white p-4 rounded-lg shadow-md;
      }
      .title {
        @apply text-lg font-semibold text-gray-900;
      }
      .content {
        @apply mt-2 text-gray-700;
      }
    </style>

    <div class="card">
      <h3 class="title">{@title}</h3>
      <div class="content">
        <#slot />
      </div>
    </div>
    """
  end
end
