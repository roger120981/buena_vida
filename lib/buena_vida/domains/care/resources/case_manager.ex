# lib/buena_vida/domains/care/resources/case_manager.ex
defmodule BuenaVida.Care.CaseManager do
  use Ash.Resource,
    domain: BuenaVida.Care,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "case_managers"
    repo BuenaVida.Repo
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      accept [:name, :email, :phone, :agencyId]
    end
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string, allow_nil?: false, constraints: [max_length: 255]
    attribute :email, :string, allow_nil?: true, constraints: [max_length: 255, match: ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/]
    attribute :phone, :string, allow_nil?: true, constraints: [max_length: 20, match: ~r/^\+?\d{6,15}$/]
    attribute :agencyId, :integer, allow_nil?: false
    create_timestamp :createdAt
    update_timestamp :updatedAt
  end

  identities do
    identity :unique_name, :name
  end

  relationships do
    has_many :participants, BuenaVida.Care.Participant do
      destination_attribute :cmID
    end

    belongs_to :agency, BuenaVida.Care.Agency do
      source_attribute :agencyId
      destination_attribute :id
      allow_nil? false
    end
  end
end
