# lib/buena_vida/domains/care/resources/participant.ex
defmodule BuenaVida.Care.Participant do
  use Ash.Resource,
    domain: BuenaVida.Care,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  json_api do
    type "participant"
    routes do
      base "/participants"
      get :read
      index :read
      post :create
      patch :update
      delete :destroy
    end
  end

  postgres do
    table "participants"
    repo BuenaVida.Repo
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true

      accept [
        :name,
        :gender,
        :medicaidId,
        :dob,
        :location,
        :community,
        :address,
        :primaryPhone,
        :secondaryPhone,
        :isActive,
        :locStartDate,
        :locEndDate,
        :pocStartDate,
        :pocEndDate,
        :units,
        :hours,
        :hdm,
        :adhc,
        :cmID
      ]
    end
  end

  validations do
    validate compare(:locEndDate,
               greater_than_or_equal_to: :locStartDate
             ),
             on: [:create, :update],
             message: "locStartDate must be before or equal to locEndDate"

    validate compare(:pocEndDate,
               greater_than_or_equal_to: :pocStartDate
             ),
             on: [:create, :update],
             message: "pocStartDate must be before or equal to pocEndDate"
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string, allow_nil?: false, constraints: [max_length: 255]
    attribute :gender, :atom, allow_nil?: false, constraints: [one_of: [:male, :female, :other]]
    attribute :medicaidId, :string, allow_nil?: false, constraints: [max_length: 50]
    attribute :dob, :date, allow_nil?: false
    attribute :location, :string, allow_nil?: false, constraints: [max_length: 100]
    attribute :community, :string, allow_nil?: false, constraints: [max_length: 100]
    attribute :address, :string, allow_nil?: false, constraints: [max_length: 255]

    attribute :primaryPhone, :string,
      allow_nil?: false,
      constraints: [max_length: 20, match: ~r/^\+?\d{6,15}$/]

    attribute :secondaryPhone, :string,
      allow_nil?: true,
      constraints: [max_length: 20, match: ~r/^\+?\d{6,15}$/]

    attribute :isActive, :boolean, allow_nil?: false, default: true
    attribute :locStartDate, :datetime, allow_nil?: false
    attribute :locEndDate, :datetime, allow_nil?: false
    attribute :pocStartDate, :datetime, allow_nil?: false
    attribute :pocEndDate, :datetime, allow_nil?: false
    attribute :units, :integer, allow_nil?: false, constraints: [min: 0]
    attribute :hours, :decimal, allow_nil?: false, constraints: [min: 0.0]
    attribute :hdm, :boolean, allow_nil?: false, default: false
    attribute :adhc, :boolean, allow_nil?: false, default: false
    attribute :cmID, :integer, allow_nil?: false
    create_timestamp :createdAt
    update_timestamp :updatedAt
  end

  relationships do
    many_to_many :caregivers, BuenaVida.Care.Caregiver do
      through BuenaVida.Care.ParticipantsOnCaregivers
      source_attribute :id
      source_attribute_on_join_resource :participantId
      destination_attribute :id
      destination_attribute_on_join_resource :caregiverId
    end

    belongs_to :caseManager, BuenaVida.Care.CaseManager do
      source_attribute :cmID
      destination_attribute :id
      allow_nil? false
    end
  end

  identities do
    identity :unique_name, :name
  end
end
