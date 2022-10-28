defmodule WandaWeb.Schemas.ResultResponse.AgentCheckError do
  @moduledoc false

  require OpenApiSpex

  alias OpenApiSpex.Schema

  alias WandaWeb.Schemas.ResultResponse.{ExpectationEvaluation, Fact}

  OpenApiSpex.schema(%{
    title: "AgentCheckError",
    description: "The result of check on a specific agent",
    type: :object,
    properties: %{
      agent_id: %Schema{type: :string, format: :uuid, description: "Agent ID"},
      facts: %Schema{type: :array, items: Fact, description: "Facts gathered from the targets"},
      expectation_evaluations: %Schema{
        type: :array,
        items: ExpectationEvaluation,
        description: "Expectation evaluated during the check execution"
      }
    },
    required: [:agent_id, :facts, :expectation_evaluations]
  })
end