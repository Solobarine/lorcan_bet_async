defmodule LorcanBetAsyncWeb.InventoryJSON do
  alias LorcanBetAsync.Inventories.Inventory

  @doc """
  Renders a list of inventories.
  """
  def index(%{inventories: inventories}) do
    %{data: for(inventory <- inventories, do: data(inventory))}
  end

  @doc """
  Renders a single inventory.
  """
  def show(%{inventory: inventory}) do
    %{data: data(inventory)}
  end

  defp data(%Inventory{} = inventory) do
    %{
      id: inventory.id,
      quantity: inventory.quantity
    }
  end
end
