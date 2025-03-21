# lib/buena_vida/domains/care/resources/caregiver.ex
defmodule BuenaVida.Care.Caregiver do
  use Ash.Resource,
    domain: BuenaVida.Care,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "caregivers"
    repo BuenaVida.Repo
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      accept [:name, :email, :phone, :isActive]
    end
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string, allow_nil?: false, constraints: [max_length: 255]
    attribute :email, :string, allow_nil?: true, constraints: [max_length: 255, match: ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/]
    attribute :phone, :string, allow_nil?: true, constraints: [max_length: 20, match: ~r/^\+?\d{6,15}$/]
    attribute :isActive, :boolean, allow_nil?: false, default: true
    create_timestamp :createdAt
    update_timestamp :updatedAt
  end

  identities do
    identity :unique_name, :name
  end

  relationships do
    many_to_many :participants, BuenaVida.Care.Participant do
      through BuenaVida.Care.ParticipantsOnCaregivers
      source_attribute :id
      source_attribute_on_join_resource :caregiverId
      destination_attribute :id
      destination_attribute_on_join_resource :participantId
    end
  end
end
