defmodule LorcanBetAsync.Repo.Migrations.CreateOrderLogs do
  use Ecto.Migration
  def change do
    create table(:order_logs) do
      add :order_id, references(:orders, on_delete: :nothing)
      add :status, :string
      add :processed_at, :date
      add :error_message, :string

      timestamps(type: :utc_datetime)
    end

    create index(:order_logs, [:order_id])
  end
end
