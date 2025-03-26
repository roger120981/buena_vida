defmodule BuenaVidaWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Module.concat(["BuenaVida.Care"])],
    open_api: "/open_api"
end
