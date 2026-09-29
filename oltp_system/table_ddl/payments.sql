CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(order_id),
    provider VARCHAR(50) NOT NULL,
    provider_transaction_id VARCHAR(150),
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    amount NUMERIC(12, 2) NOT NULL,
    currency_code CHAR(3) NOT NULL DEFAULT 'USD',
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_payments_provider_transaction UNIQUE (provider, provider_transaction_id),
    CONSTRAINT ck_payments_status CHECK (status IN ('pending', 'authorized', 'captured', 'failed', 'refunded', 'voided')),
    CONSTRAINT ck_payments_amount CHECK (amount > 0)
);

CREATE INDEX ix_payments_order_id ON payments (order_id);

CREATE TRIGGER trg_payments_last_modified
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
