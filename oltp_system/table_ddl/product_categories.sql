CREATE TABLE product_categories (
    product_id BIGINT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    category_id BIGINT NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, category_id)
);

CREATE INDEX ix_product_categories_category_id ON product_categories (category_id);

CREATE TRIGGER trg_product_categories_last_modified
BEFORE UPDATE ON product_categories
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
