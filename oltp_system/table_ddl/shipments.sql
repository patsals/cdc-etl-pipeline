CREATE TABLE shipments (
    shipment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(order_id),
    carrier VARCHAR(100),
    service_level VARCHAR(100),
    tracking_number VARCHAR(150),
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_shipments_tracking_number UNIQUE (tracking_number),
    CONSTRAINT ck_shipments_status CHECK (status IN ('pending', 'packed', 'shipped', 'in_transit', 'delivered', 'returned')),
    CONSTRAINT ck_shipments_dates CHECK (delivered_at IS NULL OR shipped_at IS NULL OR delivered_at >= shipped_at)
);

CREATE INDEX ix_shipments_order_id ON shipments (order_id);

CREATE TRIGGER trg_shipments_last_modified
BEFORE UPDATE ON shipments
FOR EACH ROW EXECUTE FUNCTION set_last_modified();
