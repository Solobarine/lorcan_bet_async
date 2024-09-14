defmodule LorcanBetAsyncWeb.InventoryControllerTest do
  use LorcanBetAsyncWeb.ConnCase

  import LorcanBetAsync.InventoriesFixtures

  alias LorcanBetAsync.Inventories.Inventory

  @create_attrs %{
    quantity: 42
  }
  @update_attrs %{
    quantity: 43
  }
  @invalid_attrs %{quantity: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all inventories", %{conn: conn} do
      conn = get(conn, ~p"/api/inventories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create inventory" do
    test "renders inventory when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/inventories", inventory: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/inventories/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/inventories", inventory: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update inventory" do
    setup [:create_inventory]

    test "renders inventory when data is valid", %{conn: conn, inventory: %Inventory{id: id} = inventory} do
      conn = put(conn, ~p"/api/inventories/#{inventory}", inventory: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/inventories/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, inventory: inventory} do
      conn = put(conn, ~p"/api/inventories/#{inventory}", inventory: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete inventory" do
    setup [:create_inventory]

    test "deletes chosen inventory", %{conn: conn, inventory: inventory} do
      conn = delete(conn, ~p"/api/inventories/#{inventory}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/inventories/#{inventory}")
      end
    end
  end

  defp create_inventory(_) do
    inventory = inventory_fixture()
    %{inventory: inventory}
  end
end
