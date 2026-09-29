CREATE TABLE order_items (
    order_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(product_id) ON DELETE SET NULL,
    sku VARCHAR(64) NOT NULL,
    product_name VARCHAR(250) NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12, 2) NOT NULL,
    discount_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    tax_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    line_total NUMERIC(12, 2) NOT NULL,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT ck_order_items_amounts CHECK (
        unit_price >= 0 AND discount_amount >= 0 AND tax_amount >= 0 AND line_total >= 0
    )
);

CREATE INDEX ix_order_items_order_id ON order_items (order_id);
CREATE INDEX ix_order_items_product_id ON order_items (product_id);

CREATE TRIGGER trg_order_items_last_modified
BEFORE UPDATE ON order_items
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
