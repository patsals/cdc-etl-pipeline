#!/bin/sh
set -eu

psql --set ON_ERROR_STOP=1 \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    --file /ddl/last_modified_trigger.sql

for ddl_file in \
    customers.sql \
    categories.sql \
    products.sql \
    addresses.sql \
    inventory.sql \
    product_categories.sql \
    shopping_carts.sql \
    shopping_cart_items.sql \
    orders.sql \
    order_items.sql \
    payments.sql \
    shipments.sql
do
    echo "Applying /ddl/${ddl_file}"
    psql --set ON_ERROR_STOP=1 \
        --username "$POSTGRES_USER" \
        --dbname "$POSTGRES_DB" \
        --file "/ddl/${ddl_file}"
done
