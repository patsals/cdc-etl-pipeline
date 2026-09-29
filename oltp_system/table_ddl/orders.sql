CREATE TABLE orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_number VARCHAR(30) NOT NULL,
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
    billing_address_id BIGINT REFERENCES addresses(address_id) ON DELETE SET NULL,
    shipping_address_id BIGINT REFERENCES addresses(address_id) ON DELETE SET NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    currency_code CHAR(3) NOT NULL DEFAULT 'USD',
    subtotal_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    tax_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    shipping_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    placed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_orders_order_number UNIQUE (order_number),
    CONSTRAINT ck_orders_status CHECK (status IN ('pending', 'paid', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')),
    CONSTRAINT ck_orders_amounts CHECK (
        subtotal_amount >= 0 AND discount_amount >= 0 AND tax_amount >= 0
        AND shipping_amount >= 0 AND total_amount >= 0
    )
);

CREATE INDEX ix_orders_customer_id_created_at ON orders (customer_id, created_at DESC);

CREATE TRIGGER trg_orders_last_modified
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
