defmodule LorcanBetAsync.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :text
      add :price, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
