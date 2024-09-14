defmodule LorcanBetAsync.InventoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LorcanBetAsync.Inventories` context.
  """

  @doc """
  Generate a inventory.
  """
  def inventory_fixture(attrs \\ %{}) do
    {:ok, inventory} =
      attrs
      |> Enum.into(%{
        quantity: 42
      })
      |> LorcanBetAsync.Inventories.create_inventory()

    inventory
  end
end
