# lib/buena_vida/domains/care/resources/agency.ex
defmodule BuenaVida.Care.Agency do
  use Ash.Resource,
    domain: BuenaVida.Care,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  json_api do
    type "agency"
    routes do
      base "/agencies"
      get :read
      index :read
      post :create
      patch :update
      delete :destroy
    end
  end

  postgres do
    table "agencies"
    repo BuenaVida.Repo
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      accept [:name]
    end
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string, allow_nil?: false, constraints: [max_length: 255]
    create_timestamp :createdAt
    update_timestamp :updatedAt
  end

  relationships do
    has_many :caseManagers, BuenaVida.Care.CaseManager do
      destination_attribute :agencyId
    end
  end

  identities do
    identity :unique_name, :name
  end
end
