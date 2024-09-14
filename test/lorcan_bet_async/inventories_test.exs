defmodule LorcanBetAsync.InventoriesTest do
  use LorcanBetAsync.DataCase

  alias LorcanBetAsync.Inventories

  describe "inventories" do
    alias LorcanBetAsync.Inventories.Inventory

    import LorcanBetAsync.InventoriesFixtures

    @invalid_attrs %{quantity: nil}

    test "list_inventories/0 returns all inventories" do
      inventory = inventory_fixture()
      assert Inventories.list_inventories() == [inventory]
    end

    test "get_inventory!/1 returns the inventory with given id" do
      inventory = inventory_fixture()
      assert Inventories.get_inventory!(inventory.id) == inventory
    end

    test "create_inventory/1 with valid data creates a inventory" do
      valid_attrs = %{quantity: 42}

      assert {:ok, %Inventory{} = inventory} = Inventories.create_inventory(valid_attrs)
      assert inventory.quantity == 42
    end

    test "create_inventory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventories.create_inventory(@invalid_attrs)
    end

    test "update_inventory/2 with valid data updates the inventory" do
      inventory = inventory_fixture()
      update_attrs = %{quantity: 43}

      assert {:ok, %Inventory{} = inventory} = Inventories.update_inventory(inventory, update_attrs)
      assert inventory.quantity == 43
    end

    test "update_inventory/2 with invalid data returns error changeset" do
      inventory = inventory_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventories.update_inventory(inventory, @invalid_attrs)
      assert inventory == Inventories.get_inventory!(inventory.id)
    end

    test "delete_inventory/1 deletes the inventory" do
      inventory = inventory_fixture()
      assert {:ok, %Inventory{}} = Inventories.delete_inventory(inventory)
      assert_raise Ecto.NoResultsError, fn -> Inventories.get_inventory!(inventory.id) end
    end

    test "change_inventory/1 returns a inventory changeset" do
      inventory = inventory_fixture()
      assert %Ecto.Changeset{} = Inventories.change_inventory(inventory)
    end
  end
end
