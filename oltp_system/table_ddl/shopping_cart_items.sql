CREATE TABLE shopping_cart_items (
    cart_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cart_id BIGINT NOT NULL REFERENCES shopping_carts(cart_id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12, 2) NOT NULL,
    added_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_shopping_cart_items_cart_product UNIQUE (cart_id, product_id),
    CONSTRAINT ck_shopping_cart_items_quantity CHECK (quantity > 0),
    CONSTRAINT ck_shopping_cart_items_unit_price CHECK (unit_price >= 0)
);

CREATE INDEX ix_shopping_cart_items_product_id ON shopping_cart_items (product_id);

CREATE TRIGGER trg_shopping_cart_items_last_modified
BEFORE UPDATE ON shopping_cart_items
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
