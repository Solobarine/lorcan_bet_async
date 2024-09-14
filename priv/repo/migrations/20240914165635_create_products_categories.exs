defmodule LorcanBetAsync.Repo.Migrations.CreateProductsCategories do
  use Ecto.Migration

  def change do
    create table(:products_categories) do
      add :product_id, references(:products, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
  end
end
