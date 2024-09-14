defmodule LorcanBetAsync.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LorcanBetAsync.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        quantity: 42,
        status: "some status"
      })
      |> LorcanBetAsync.Orders.create_order()

    order
  end
end
