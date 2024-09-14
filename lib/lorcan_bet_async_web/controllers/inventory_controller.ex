defmodule LorcanBetAsyncWeb.InventoryController do
  use LorcanBetAsyncWeb, :controller

  alias LorcanBetAsync.Inventories
  alias LorcanBetAsync.Inventories.Inventory

  action_fallback LorcanBetAsyncWeb.FallbackController

  def index(conn, _params) do
    inventories = Inventories.list_inventories()
    render(conn, :index, inventories: inventories)
  end

  def create(conn, %{"inventory" => inventory_params}) do
    with {:ok, %Inventory{} = inventory} <- Inventories.create_inventory(inventory_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/inventories/#{inventory}")
      |> render(:show, inventory: inventory)
    end
  end

  def show(conn, %{"id" => id}) do
    inventory = Inventories.get_inventory!(id)
    render(conn, :show, inventory: inventory)
  end

  def update(conn, %{"id" => id, "inventory" => inventory_params}) do
    inventory = Inventories.get_inventory!(id)

    with {:ok, %Inventory{} = inventory} <- Inventories.update_inventory(inventory, inventory_params) do
      render(conn, :show, inventory: inventory)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventory = Inventories.get_inventory!(id)

    with {:ok, %Inventory{}} <- Inventories.delete_inventory(inventory) do
      send_resp(conn, :no_content, "")
    end
  end
end
