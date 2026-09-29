CREATE TABLE inventory (
    inventory_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    quantity_on_hand INTEGER NOT NULL DEFAULT 0,
    quantity_reserved INTEGER NOT NULL DEFAULT 0,
    reorder_point INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_inventory_product_id UNIQUE (product_id),
    CONSTRAINT ck_inventory_quantities CHECK (
        quantity_on_hand >= 0
        AND quantity_reserved >= 0
        AND quantity_reserved <= quantity_on_hand
        AND reorder_point >= 0
    )
);

CREATE TRIGGER trg_inventory_last_modified
BEFORE UPDATE ON inventory
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
