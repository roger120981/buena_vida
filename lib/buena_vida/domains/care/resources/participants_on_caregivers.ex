# lib/buena_vida/domains/care/resources/participants_on_caregivers.ex
defmodule BuenaVida.Care.ParticipantsOnCaregivers do
  use Ash.Resource,
    domain: BuenaVida.Care,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "participants_on_caregivers"
    repo BuenaVida.Repo
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      accept [:participantId, :caregiverId, :assignedAt, :assignedBy]
    end
  end

  attributes do
    attribute :assignedAt, :datetime, allow_nil?: false, default: &DateTime.utc_now/0
    attribute :assignedBy, :string, allow_nil?: false, constraints: [max_length: 100]
    attribute :participantId, :integer, allow_nil?: false, primary_key?: true
    attribute :caregiverId, :integer, allow_nil?: false, primary_key?: true
  end

  identities do
    identity :unique_assignment, [:participantId, :caregiverId]
  end

  relationships do
    belongs_to :participant, BuenaVida.Care.Participant do
      source_attribute :participantId
      destination_attribute :id
      allow_nil? false
    end

    belongs_to :caregiver, BuenaVida.Care.Caregiver do
      source_attribute :caregiverId
      destination_attribute :id
      allow_nil? false
    end
  end
end
