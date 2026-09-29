CREATE TABLE shopping_carts (
    cart_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_shopping_carts_status CHECK (status IN ('active', 'abandoned', 'converted'))
);

CREATE INDEX ix_shopping_carts_customer_id ON shopping_carts (customer_id);

CREATE TRIGGER trg_shopping_carts_last_modified
BEFORE UPDATE ON shopping_carts
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
