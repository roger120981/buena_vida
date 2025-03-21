# lib/buena_vida/domains/care/resources/agency.ex
defmodule BuenaVida.Care.Agency do
  use Ash.Resource,
    domain: BuenaVida.Care,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "agencies"
    repo BuenaVida.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string, allow_nil?: false, constraints: [max_length: 255]
    create_timestamp :createdAt
    update_timestamp :updatedAt
  end

  identities do
    identity :unique_name, :name
  end

  relationships do
    has_many :caseManagers, BuenaVida.Care.CaseManager do
      destination_attribute :agencyId
    end
  end
end
