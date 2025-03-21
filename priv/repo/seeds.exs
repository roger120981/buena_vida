# priv/repo/seeds.exs
defmodule BuenaVida.Seeds do
  alias BuenaVida.Care.{Agency, CaseManager, Caregiver, Participant, ParticipantsOnCaregivers}

  # Función auxiliar para transformar el teléfono al formato esperado
  defp format_phone(phone) do
    cleaned = String.replace(phone, ~r/[^+\d]/, "")
    if String.match?(cleaned, ~r/^\+?\d{6,15}$/) do
      cleaned
    else
      "+1#{Enum.random(200..999)}#{Enum.random(100..999)}#{Enum.random(1000..9999)}"
    end
  end

  # Crear o recuperar una agencia
  defp seed_agency do
    case Ash.get(Agency, %{name: "Care Agency One"}, domain: BuenaVida.Care) do
      {:ok, agency} ->
        agency
      {:error, _} ->
        Ash.create!(Agency, %{name: "Care Agency One"}, domain: BuenaVida.Care)
    end
  end

  # Crear case managers
  defp seed_case_managers(agency, count) do
    Enum.map(1..count, fn _ ->
      Ash.create!(CaseManager, %{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        phone: format_phone(Faker.Phone.EnUs.phone()),
        agencyId: agency.id
      }, domain: BuenaVida.Care)
    end)
  end

  # Crear caregivers
  defp seed_caregivers(count) do
    Enum.map(1..count, fn _ ->
      Ash.create!(Caregiver, %{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        phone: format_phone(Faker.Phone.EnUs.phone()),
        isActive: Enum.random([true, false])
      }, domain: BuenaVida.Care)
    end)
  end

  # Crear participants
  defp seed_participants(case_managers, count) do
    Enum.map(1..count, fn _ ->
      Ash.create!(Participant, %{
        name: Faker.Person.name(),
        gender: Enum.random([:male, :female, :other]),
        medicaidId: "MED#{Faker.Code.isbn() |> String.replace("-", "")}",
        dob: Date.add(Date.utc_today(), -Enum.random(365 * 20..365 * 80)),
        location: Enum.random(["Downtown", "Suburbs", "Rural"]),
        community: Enum.random(["North", "South", "East", "West"]),
        address: Faker.Address.street_address(),
        primaryPhone: format_phone(Faker.Phone.EnUs.phone()),
        secondaryPhone: if(Enum.random([true, false]), do: format_phone(Faker.Phone.EnUs.phone()), else: nil),
        isActive: Enum.random([true, false]),
        locStartDate: DateTime.utc_now() |> DateTime.add(-Enum.random(1..365), :day),
        locEndDate: DateTime.utc_now() |> DateTime.add(Enum.random(1..365), :day),
        pocStartDate: DateTime.utc_now() |> DateTime.add(-Enum.random(1..365), :day),
        pocEndDate: DateTime.utc_now() |> DateTime.add(Enum.random(1..365), :day),
        units: Enum.random(1..100),
        hours: Decimal.new("#{Enum.random(1..50)}.#{Enum.random(1..9)}"),
        hdm: Enum.random([true, false]),
        adhc: Enum.random([true, false]),
        cmID: Enum.random(case_managers).id
      }, domain: BuenaVida.Care)
    end)
  end

  # Asignar caregivers a participants
  defp seed_participant_caregivers(participants, caregivers) do
    Enum.each(participants, fn participant ->
      caregiver_subset = Enum.take_random(caregivers, Enum.random(1..5))
      Enum.each(caregiver_subset, fn caregiver ->
        Ash.create!(ParticipantsOnCaregivers, %{
          participantId: participant.id,
          caregiverId: caregiver.id,
          assignedAt: DateTime.utc_now(),
          assignedBy: "Admin"
        }, domain: BuenaVida.Care)
      end)
    end)
  end

  # Función principal para ejecutar los seeds
  def run do
    agency = seed_agency()
    case_managers = seed_case_managers(agency, 5)
    caregivers = seed_caregivers(50)
    participants = seed_participants(case_managers, 1000)
    seed_participant_caregivers(participants, caregivers)

    IO.puts("Seeding completed: 1 agency, 5 case managers, 50 caregivers, 1000 participants, and their relationships.")
  end
end

# Ejecutar el seeding
BuenaVida.Seeds.run()
