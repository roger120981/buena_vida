# lib/buena_vida/domains/care/domain.ex
defmodule BuenaVida.Care do
  use Ash.Domain

  @doc "Domain for care management resources in Buena Vida."
  resources do
    resource BuenaVida.Care.Participant
    resource BuenaVida.Care.Caregiver
    resource BuenaVida.Care.ParticipantsOnCaregivers
    resource BuenaVida.Care.Agency
    resource BuenaVida.Care.CaseManager
  end
end
