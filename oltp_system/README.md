# Example E-Commerce OLTP System

This directory contains PostgreSQL DDL for an example e-commerce transactional system. Each table is defined in its own file under [`table_ddl`](table_ddl/).

Every table includes a `last_modified` column. It defaults to the row creation time and a shared trigger updates it automatically whenever that row is changed.

## Tables

| Table | Purpose |
| --- | --- |
| [`customers`](table_ddl/customers.sql) | Customer accounts and contact details. |
| [`addresses`](table_ddl/addresses.sql) | Customer shipping, billing, and other saved addresses. |
| [`categories`](table_ddl/categories.sql) | Hierarchical product catalog categories. |
| [`products`](table_ddl/products.sql) | Sellable product catalog entries and current base price. |
| [`product_categories`](table_ddl/product_categories.sql) | Many-to-many assignment of products to categories. |
| [`inventory`](table_ddl/inventory.sql) | Per-product on-hand, reserved, and reorder quantities. |
| [`shopping_carts`](table_ddl/shopping_carts.sql) | Customer shopping carts and their lifecycle status. |
| [`shopping_cart_items`](table_ddl/shopping_cart_items.sql) | Products and quantities in each shopping cart. |
| [`orders`](table_ddl/orders.sql) | Order headers, totals, lifecycle status, and selected addresses. |
| [`order_items`](table_ddl/order_items.sql) | Purchased-product line items, including price snapshots. |
| [`payments`](table_ddl/payments.sql) | Payment attempts and their provider transaction details. |
| [`shipments`](table_ddl/shipments.sql) | Fulfillment and delivery tracking records for orders. |

## Entity Relationship Diagram

```mermaid
erDiagram
    CUSTOMERS ||--o{ ADDRESSES : saves
    CUSTOMERS ||--o{ SHOPPING_CARTS : owns
    CUSTOMERS ||--o{ ORDERS : places

    CATEGORIES ||--o{ CATEGORIES : parents
    PRODUCTS ||--o{ PRODUCT_CATEGORIES : is_assigned
    CATEGORIES ||--o{ PRODUCT_CATEGORIES : includes
    PRODUCTS ||--|| INVENTORY : has

    SHOPPING_CARTS ||--o{ SHOPPING_CART_ITEMS : contains
    PRODUCTS ||--o{ SHOPPING_CART_ITEMS : added_as

    ADDRESSES ||--o{ ORDERS : used_for_billing
    ADDRESSES ||--o{ ORDERS : used_for_shipping
    ORDERS ||--o{ ORDER_ITEMS : contains
    PRODUCTS o|--o{ ORDER_ITEMS : captured_from
    ORDERS ||--o{ PAYMENTS : has
    ORDERS ||--o{ SHIPMENTS : fulfilled_by

    CUSTOMERS {
        bigint customer_id PK
        varchar email UK
        varchar first_name
        varchar last_name
        timestamptz last_modified
    }
    ADDRESSES {
        bigint address_id PK
        bigint customer_id FK
        varchar address_type
        boolean is_default
        timestamptz last_modified
    }
    CATEGORIES {
        bigint category_id PK
        bigint parent_category_id FK
        varchar name
        varchar slug UK
        timestamptz last_modified
    }
    PRODUCTS {
        bigint product_id PK
        varchar sku UK
        varchar name
        numeric unit_price
        timestamptz last_modified
    }
    PRODUCT_CATEGORIES {
        bigint product_id PK, FK
        bigint category_id PK, FK
        timestamptz last_modified
    }
    INVENTORY {
        bigint inventory_id PK
        bigint product_id FK, UK
        int quantity_on_hand
        int quantity_reserved
        timestamptz last_modified
    }
    SHOPPING_CARTS {
        bigint cart_id PK
        bigint customer_id FK
        varchar status
        timestamptz last_modified
    }
    SHOPPING_CART_ITEMS {
        bigint cart_item_id PK
        bigint cart_id FK
        bigint product_id FK
        int quantity
        timestamptz last_modified
    }
    ORDERS {
        bigint order_id PK
        varchar order_number UK
        bigint customer_id FK
        bigint billing_address_id FK
        bigint shipping_address_id FK
        numeric total_amount
        varchar status
        timestamptz last_modified
    }
    ORDER_ITEMS {
        bigint order_item_id PK
        bigint order_id FK
        bigint product_id FK
        int quantity
        numeric line_total
        timestamptz last_modified
    }
    PAYMENTS {
        bigint payment_id PK
        bigint order_id FK
        varchar status
        numeric amount
        timestamptz last_modified
    }
    SHIPMENTS {
        bigint shipment_id PK
        bigint order_id FK
        varchar tracking_number UK
        varchar status
        timestamptz last_modified
    }
```

## Suggested creation order

Run the DDL files in this dependency order:

1. `customers.sql`
2. `categories.sql`
3. `products.sql`
4. `addresses.sql`
5. `inventory.sql`
6. `product_categories.sql`
7. `shopping_carts.sql`
8. `shopping_cart_items.sql`
9. `orders.sql`
10. `order_items.sql`
11. `payments.sql`
12. `shipments.sql`

## Run locally with Docker

From the project root, start PostgreSQL and initialize the schema:

```sh
docker compose up -d
```

The database is available at `localhost:5432` with database `ecommerce`, user `ecommerce_app`, and password `ecommerce_app_password`. On its first start, Compose runs [`init-db.sh`](init-db.sh), which applies every DDL file in the creation order above. The database data is stored in the `postgres_data` Docker volume, so initialization does not run again while that volume exists.

To reset the local database and initialize it again:

```sh
docker compose down -v
docker compose up -d
```
