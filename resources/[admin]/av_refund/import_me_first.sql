CREATE TABLE IF NOT EXISTS av_refund (
  identifier varchar(50) NOT NULL,
  items longtext DEFAULT NULL,
  claimed TINYINT(1) DEFAULT 0,
  created timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_identifier ON av_refund (identifier);