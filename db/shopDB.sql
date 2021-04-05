CREATE TABLE "customer" (
  "customer_id" integer PRIMARY KEY NOT NULL,
  "first_name" "character varying(100)" NOT NULL,
  "middle_name" "character varying(50)",
  "last_name" "character varying(150)" NOT NULL,
  "email_address" "character varying(200)" NOT NULL,
  "created_at" timestamp NOT NULL,
  "username" "character varying(200)" NOT NULL,
  "user_type" "character (3)" NOT NULL
);

CREATE TABLE "customer_address" (
  "address_id" integer PRIMARY KEY NOT NULL,
  "customer_id" integer NOT NULL,
  "address_street_no" "character varying(50)" NOT NULL,
  "address_street_name" "character varying(100)" NOT NULL,
  "address_city" "character varying(50)" NOT NULL,
  "address_state" "character varying(50)",
  "address_postal_code" "character varying(25)" NOT NULL,
  "address_country_code" "character varying(2)" NOT NULL
);

CREATE TABLE "customer_login" (
  "login_id" integer PRIMARY KEY NOT NULL,
  "customer_id" integer NOT NULL,
  "password_hash" "character varying(256)" NOT NULL,
  "locked_out" boolean NOT NULL
);

CREATE TABLE "order" (
  "order_id" integer PRIMARY KEY NOT NULL,
  "customer_id" integer NOT NULL,
  "status_code_id" integer NOT NULL,
  "customer_comments" "character varying(300)",
  "created_at" timestamp NOT NULL
);

CREATE TABLE "order_item" (
  "order_item_id" integer PRIMARY KEY NOT NULL,
  "order_id" integer NOT NULL,
  "product_id" integer NOT NULL,
  "quantity" integer NOT NULL,
  "price" numeric NOT NULL
);

CREATE TABLE "order_status_code" (
  "status_code_id" integer PRIMARY KEY NOT NULL,
  "status_code" "character varying(20)" NOT NULL,
  "description" "character varying(200)" NOT NULL
);

CREATE TABLE "product" (
  "id" integer PRIMARY KEY NOT NULL,
  "name" "character varying(100)" NOT NULL,
  "sku" "character varying(50)" NOT NULL,
  "fullDescription" "character varying(500)" NOT NULL,
  "price" numeric NOT NULL,
  "vendor_id" integer NOT NULL,
  "discount" numeric NOT NULL,
  "offerEnd" timestamp NOT NULL,
  "new" boolean NOT NULL,
  "rating" integer NOT NULL,
  "saleCount" integer NOT NULL,
  "category" "character varying" NOT NULL,
  "tag" "character varying" NOT NULL,
  "stock" integer NOT NULL,
  "image" "character varying" NOT NULL,
  "shortDescription" "character varying(250)" NOT NULL,
  "weight" "character varying(100)" NOT NULL,
  "dimensions" "character varying(100)" NOT NULL,
  "materials" "character varying(250)" NOT NULL,
  "otherInfo" "character varying(250)" NOT NULL,
  "affiliateLink" "character varying(500)"
);

CREATE TABLE "product_vendor" (
  "vendor_id" integer PRIMARY KEY NOT NULL,
  "company_code" "character varying(50)" NOT NULL,
  "name" "character varying(150)" NOT NULL,
  "description" "character varying(500)" NOT NULL,
  "address_street_no" "character varying(50)" NOT NULL,
  "address_street_name" "character varying(100)" NOT NULL,
  "address_city" "character varying(50)" NOT NULL,
  "address_state" "character varying(50)",
  "address_postal_code" "character varying(25)" NOT NULL,
  "address_country_code" "character varying(2)" NOT NULL
);

CREATE TABLE "shopping_cart" (
  "cart_id" integer PRIMARY KEY NOT NULL,
  "customer_id" integer NOT NULL,
  "status_code_id" integer NOT NULL,
  "created_at" timestamp NOT NULL
);

CREATE TABLE "shopping_cart_item" (
  "cart_item_id" integer PRIMARY KEY NOT NULL,
  "cart_id" integer NOT NULL,
  "product_id" integer NOT NULL,
  "quantity" integer NOT NULL,
  "price" numeric NOT NULL
);

CREATE TABLE "shopping_cart_status" (
  "status_code_id" integer PRIMARY KEY NOT NULL,
  "status_code" "character varying(20)" NOT NULL,
  "description" "character varying(200)" NOT NULL
);

ALTER TABLE "customer_address" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "customer_login" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "order" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "order" ADD FOREIGN KEY ("status_code_id") REFERENCES "order_status_code" ("status_code_id");

ALTER TABLE "order_item" ADD FOREIGN KEY ("order_id") REFERENCES "order" ("order_id");

ALTER TABLE "order_item" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id");

ALTER TABLE "product" ADD FOREIGN KEY ("vendor_id") REFERENCES "product_vendor" ("vendor_id");

ALTER TABLE "shopping_cart" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "shopping_cart" ADD FOREIGN KEY ("status_code_id") REFERENCES "shopping_cart_status" ("status_code_id");

ALTER TABLE "shopping_cart_item" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id");

ALTER TABLE "shopping_cart_item" ADD FOREIGN KEY ("cart_id") REFERENCES "shopping_cart" ("cart_id");
