CREATE TABLE products (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku VARCHAR(64) NOT NULL,
    name VARCHAR(250) NOT NULL,
    description TEXT,
    unit_price NUMERIC(12, 2) NOT NULL,
    currency_code CHAR(3) NOT NULL DEFAULT 'USD',
    weight_grams INTEGER,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_products_sku UNIQUE (sku),
    CONSTRAINT ck_products_unit_price CHECK (unit_price >= 0),
    CONSTRAINT ck_products_weight CHECK (weight_grams IS NULL OR weight_grams >= 0)
);

CREATE TRIGGER trg_products_last_modified
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
