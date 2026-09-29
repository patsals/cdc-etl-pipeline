CREATE TABLE addresses (
    address_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    address_type VARCHAR(20) NOT NULL DEFAULT 'shipping',
    recipient_name VARCHAR(200) NOT NULL,
    line1 VARCHAR(200) NOT NULL,
    line2 VARCHAR(200),
    city VARCHAR(100) NOT NULL,
    state_or_region VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country_code CHAR(2) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_addresses_type CHECK (address_type IN ('shipping', 'billing', 'other'))
);

CREATE INDEX ix_addresses_customer_id ON addresses (customer_id);

CREATE TRIGGER trg_addresses_last_modified
BEFORE UPDATE ON addresses
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
