defmodule Wanda.Policy do
  @moduledoc """
  Handles integration events.
  """

  alias Trento.Checks.V1.{
    ExecutionRequested,
    FactsGathered
  }

  alias Wanda.Execution.{
    Fact,
    Target
  }

  require Logger

  @spec handle_event(ExecutionRequested.t() | FactsGathered.t()) :: :ok | {:error, any}
  def handle_event(event) do
    Logger.debug("Handling event #{inspect(event)}")

    handle(event)
  end

  defp handle(%ExecutionRequested{
         execution_id: execution_id,
         group_id: agent_id,
         targets: targets
       }) do
    execution_impl().start_execution(
      execution_id,
      agent_id,
      Enum.map(targets, fn %{agent_id: agent_id, checks: checks} ->
        %Target{agent_id: agent_id, checks: checks}
      end)
    )
  end

  defp handle(%FactsGathered{
         execution_id: execution_id,
         agent_id: agent_id,
         facts_gathered: facts_gathered
       }) do
    execution_impl().receive_facts(
      execution_id,
      agent_id,
      Enum.map(facts_gathered, fn %{check_id: check_id, name: name, value: {_, value}} ->
        %Fact{check_id: check_id, name: name, value: value}
      end)
    )
  end

  defp execution_impl, do: Application.fetch_env!(:wanda, Wanda.Policy)[:execution_impl]
end