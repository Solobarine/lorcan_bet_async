defmodule LorcanBetAsync.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :status, :string
    field :quantity, :integer
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:quantity, :status])
    |> validate_required([:quantity, :status])
  end
end
