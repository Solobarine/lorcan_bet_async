defmodule LorcanBetAsync.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias LorcanBetAsync.Repo

  alias LorcanBetAsync.Orders.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """

  ## Order Processing

  defp schedule_order_processing(order) do
    Oban.insert!(%ProcessOrderJob{args: %{"order_id" => order.id}})
  end

  def perform(%Oban.Job{args: %{"order_id" => order_id}}) do
    order = Repo.get!(Order, order_id)

    case process_order(order) do
      :ok -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

  defp process_order(order) do
    product = Products.get_product!(order.product_id)

    with {:ok, _inventory} <- reserve_inventory(product, order.quantity),
         {:ok, _payment} <- process_payment(order),
         {:ok, _} <- update_order_status(order, "processed") do
      log_order(order, "processed", nil)
      :ok
    else
      {:error, reason} ->
        log_order(order, "failed", reason)
        handle_order_failure(order, reason)
    end
  end

  ## Reserve Quantity of Product in Inventory

  defp reserve_inventory(product, quantity) do
    inventory = Inventory.get_inventory!(product.id)

    if inventory.quantity >= quantity do
      Inventory.update_inventory(inventory, %{quantity: inventory.quantity - quantity})
      {:ok, inventory}
    else
      {:error, "Insufficient inventory"}
    end
  end

  ## Simulate Payment Processing

  defp process_payment(order) do
    Task.async(fn ->
      :timer.sleep(2000)
      case :rand.uniform(2) do
        1 -> {:ok, %{status: "success"}}
        2 -> {:error, "Payment failed"}
      end
    end)
    |> Task.await()
  end

  ## Order Failure Handling and Retry

  defp handle_order_failure(order, reason) do
    retry_order(order, reason)
  end

  defp retry_order(order, reason) do
    if order.retry_count < @retry_limit do
      updated_order = %Order{order | retry_count: order.retry_count + 1}
      Repo.update!(updated_order)
      schedule_order_processing(order)
    else
      release_inventory(order)
    end
  end

  defp release_inventory(order) do
    product = Products.get_product!(order.product_id)
    inventory = Inventory.get_inventory!(product.id)
    Inventory.update_inventory(inventory, %{quantity: inventory.quantity + order.quantity})
  end

  ## Update Order Status

  defp update_order_status(%Order{} = order, status) do
    order
    |> Order.changeset(%{status: status})
    |> Repo.update()
  end

  ## Log Orders based on status

  defp log_order(order, status, error_message) do
    %OrderLogs{}
    |> OrderLogs.changeset(%{
      order_id: order.id,
      status: status,
      processed_at: DateTime.utc_now(),
      error_message: error_message
    })
    |> Repo.insert()
  end

  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end
end
