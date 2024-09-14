
# Inventory and Order Management Microservice

This microservice is built using Phoenix and provides a RESTful API for managing products, inventory, and orders. It supports asynchronous order processing, ensuring distributed consistency and handling of concurrent inventory updates. The system is resilient with retry mechanisms and failure handling in order processing.

## Features
1. **Product Management**: 
    - Create, update, and delete products.
2. **Inventory Management**: 
    - Manage product inventory levels, handle concurrent inventory updates, and ensure data integrity.
3. **Order Processing**: 
    - Asynchronous order handling.
    - Ensures that each order is processed only once.
    - Includes failure handling and retry mechanisms.
4. **Distributed Consistency**: 
    - Ensures eventual consistency across systems, especially in the presence of asynchronous payments and order processing.
5. **Database Migration**: 
    - Safely introduces product categories without downtime or breaking changes.
6. **Resiliency in Async Systems**: 
    - Implements retry mechanisms and failure handling in the order processing system.

## Tech Stack
- **Phoenix Framework**: Backend framework.
- **PostgreSQL**: Database for storing products, orders, inventory, and order logs.
- **Oban**: For asynchronous background job processing (used for handling orders and retries).
- **Ecto**: Database wrapper and query generator for Elixir.

## Requirements
- Elixir 1.17.1 (managed with `asdf`)
- PostgreSQL
- Phoenix Framework
- Oban for background jobs

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd inventory_order_service
```

### 2. Install Dependencies
```bash
mix deps.get
```

### 3. Setup the Database
Make sure PostgreSQL is running, and create and migrate the database.
```bash
mix ecto.create
mix ecto.migrate
```

To reset the database, you can use:
```bash
mix ecto.reset
```

### 4. Running the Application
To start your Phoenix server:

```bash
mix phx.server
```

You can now visit [`localhost:4000`](http://localhost:4000) from your browser or test the API using a tool like Postman.

### 5. Running Tests
Run the following command to execute the tests:
```bash
mix test
```


## Order Processing
Order processing happens asynchronously, and status updates are logged in the `OrderLogs`.

### Asynchronous Order Handling
- Each order is processed asynchronously via Oban jobs. 
- Orders are processed in two phases:
  1. **Reserve Inventory**: Ensure sufficient inventory exists before processing the order.
  2. **Payment Processing**: A payment simulation is made asynchronously. If it fails, the system retries the order until a limit is reached.

### Retry Mechanism
- Orders that fail due to insufficient inventory or payment failure are retried up to 3 times.
- If retries are exhausted, inventory is released.

## Database Schema

### Tables

- **Products**: Stores product details (`id`, `name`, `description`, `price`).
- **Inventory**: Tracks product inventory levels (`id`, `product_id`, `quantity`).
- **Orders**: Manages customer orders (`id`, `product_id`, `quantity`, `status`).
- **OrderLogs**: Logs the processing status of each order (`id`, `order_id`, `status`, `processed_at`, `error_message`).

### Database Migrations
Migrations are used to alter the database schema without causing downtime. For example, the migration to introduce product categories includes:
- Creating the `Categories` table (`id`, `name`).
- Creating the `Product_Categories` table (`product_id`, `category_id`).

```bash
mix ecto.gen.migration create_categories
mix ecto.migrate
```

## Resiliency and Distributed Consistency

The service simulates an external payment system. If the payment succeeds, the order is marked as processed. If the payment fails, inventory is released, and the system retries the payment after a delay.

### Failure Handling
- Simulates payment delays and random failures.
- Ensures eventual consistency in inventory and order status.

## License
MIT License
