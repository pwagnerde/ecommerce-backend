CREATE DATABASE shopdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'German_Germany.1252';

CREATE TABLE public.customer (
    customer_id serial NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(50),
    last_name character varying(150) NOT NULL,
    email_address character varying(200) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    username character varying(200) NOT NULL,
    user_type character(3) NOT NULL
);

CREATE TABLE public.customer_address (
    address_id serial NOT NULL,
    customer_id integer NOT NULL,
    address_street_no character varying(50) NOT NULL,
    address_street_name character varying(100) NOT NULL,
    address_city character varying(50) NOT NULL,
    address_state character varying(50),
    address_postal_code character varying(25) NOT NULL,
    address_country_code character varying(2) NOT NULL
);

CREATE TABLE public.customer_login (
    login_id serial NOT NULL,
    customer_id integer NOT NULL,
    password_hash character varying(256) NOT NULL,
    locked_out boolean DEFAULT false NOT NULL
);

CREATE TABLE public."order" (
    order_id serial NOT NULL,
    customer_id integer NOT NULL,
    status_code_id integer NOT NULL,
    customer_comments character varying(300),
    created_at timestamp without time zone NOT NULL,
    total numeric DEFAULT 0 NOT NULL
);

CREATE TABLE public.order_item (
    order_item_id serial NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    final_price numeric NOT NULL
);

CREATE TABLE public.order_status_code (
    status_code_id serial NOT NULL,
    status_code character varying(20) NOT NULL,
    description character varying(200) NOT NULL
);

CREATE TABLE public.product (
    product_id serial NOT NULL,
    name character varying(100) NOT NULL,
    sku character varying(50) NOT NULL,
    "fullDescription" character varying(500) NOT NULL,
    price numeric DEFAULT 0 NOT NULL,
    vendor_id integer NOT NULL,
    discount numeric DEFAULT 0 NOT NULL,
    "offerEnd" timestamp without time zone NOT NULL,
    new boolean DEFAULT true NOT NULL,
    rating integer NOT NULL,
    "saleCount" integer DEFAULT 0 NOT NULL,
    category character varying[] NOT NULL,
    tag character varying[] NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    image character varying[] NOT NULL,
    "shortDescription" character varying(250) NOT NULL,
    weight character varying(100) NOT NULL,
    dimensions character varying(100) NOT NULL,
    materials character varying(250) NOT NULL,
    "otherInfo" character varying(250) NOT NULL,
    "affiliateLink" character varying(500)
);

CREATE TABLE public.product_vendor (
    vendor_id serial NOT NULL,
    company_code character varying(50) NOT NULL,
    name character varying(150) NOT NULL,
    description character varying(500) NOT NULL,
    address_street_no character varying(50) NOT NULL,
    address_street_name character varying(100) NOT NULL,
    address_city character varying(50) NOT NULL,
    address_state character varying(50),
    address_postal_code character varying(25) NOT NULL,
    address_country_code character varying(2) NOT NULL
);

CREATE TABLE public.shopping_cart (
    cart_id serial NOT NULL,
    customer_id integer NOT NULL,
    status_code_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);

CREATE TABLE public.shopping_cart_item (
    cart_item_id serial NOT NULL,
    cart_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL
);

CREATE TABLE public.shopping_cart_status (
    status_code_id serial NOT NULL,
    status_code character varying(20) NOT NULL,
    description character varying(200) NOT NULL
);


ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_key UNIQUE (customer_id);
    
ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (address_id);

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_address_key UNIQUE (email_address);
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_username_key UNIQUE (username);

ALTER TABLE ONLY public.customer_login
    ADD CONSTRAINT customer_login_customer_id_key UNIQUE (customer_id);

ALTER TABLE ONLY public.customer_login
    ADD CONSTRAINT customer_login_pkey PRIMARY KEY (login_id);

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (order_item_id);

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);

ALTER TABLE ONLY public.order_status_code
    ADD CONSTRAINT order_status_code_pkey PRIMARY KEY (status_code_id);

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);

ALTER TABLE ONLY public.product_vendor
    ADD CONSTRAINT product_vendor_pkey PRIMARY KEY (vendor_id);

ALTER TABLE ONLY public.shopping_cart_status
    ADD CONSTRAINT shopping_card_status_pkey PRIMARY KEY (status_code_id);

ALTER TABLE ONLY public.shopping_cart_item
    ADD CONSTRAINT shopping_cart_item_pkey PRIMARY KEY (cart_item_id);

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_pkey PRIMARY KEY (cart_id);

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE CASCADE;

ALTER TABLE ONLY public.customer_login
    ADD CONSTRAINT customer_login_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE CASCADE;

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE SET NULL;

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id) ON DELETE RESTRICT;

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id) ON DELETE RESTRICT;

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_status_code_id_fkey FOREIGN KEY (status_code_id) REFERENCES public.order_status_code(status_code_id) ON DELETE RESTRICT;

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.product_vendor(vendor_id) ON DELETE RESTRICT;

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE SET NULL;

ALTER TABLE ONLY public.shopping_cart_item
    ADD CONSTRAINT shopping_cart_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id) ON DELETE CASCADE;

ALTER TABLE ONLY public.shopping_cart_item
    ADD CONSTRAINT shopping_cart_item_shopping_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES public.shopping_cart(cart_id) ON DELETE CASCADE NOT VALID;

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_status_code_id_fkey FOREIGN KEY (status_code_id) REFERENCES public.shopping_cart_status(status_code_id) ON DELETE RESTRICT;



INSERT INTO public.product_vendor (company_code, name, description, address_street_no, address_street_name, address_city, address_state, address_postal_code, address_country_code) VALUES ('LL', 'Lululemon', 'Founded in Vancouver, Canada in 1998, lululemon athletica is a technical athletic apparel company for yoga, running, training and most other sweaty pursuits.', '28', 'Westendstrasse', 'Frankfurt', 'HE', '60235', 'DE');
INSERT INTO public.product_vendor (company_code, name, description, address_street_no, address_street_name, address_city, address_state, address_postal_code, address_country_code) VALUES ('LE', 'Ledger', 'Ledger was launched in 2014 by eight experts with complementary backgrounds in embedded security, cryptocurrencies and entrepreneurship, united around the idea of creating secure solutions for blockchain applications. We now have over 130 employees in Paris, Vierzon and San Francisco.', '1', 'rue du Mail', 'Paris', NULL, '75002', 'FR');

INSERT INTO public.product (name, sku, "fullDescription", price, vendor_id, discount, "offerEnd", new, rating, "saleCount", category, tag, stock, image, "shortDescription", weight, dimensions, materials, "otherInfo", "affiliateLink") VALUES ('Ledger Nano X', 'p2021l01', 'Install up to 100 crypto applications at the same time on your Ledger Nano X. More than 1500 coins and tokens supported, including Bitcoin, Ethereum, XRP, Litecoin. Securely manage your crypto on-the-go. Connect your Ledger Nano X to your smartphone with Ledger Live and start managing your assets everywhere.', 119, 2, 10, '2021-10-05 12:11:00', true, 5, 120, '{electronics}', '{electronics}', 45, '{/img/product/ledger/ledger-nano-x-1.png}', 'The next level hardware wallet. Buy & Securely manage your crypto in one single-app, anywhere you go. Become the only one in charge of your assets.', '34 g', '72 mm x 18.6 mm x 11.75 mm', 'Brushed stainless steel and plastic', '1 hardware wallet, 1 USB-C to USB-A cable, 1 getting started leaflet, 3 recovery sheets, 1 keychain strap', NULL);
INSERT INTO public.product (name, sku, "fullDescription", price, vendor_id, discount, "offerEnd", new, rating, "saleCount", category, tag, stock, image, "shortDescription", weight, dimensions, materials, "otherInfo", "affiliateLink") VALUES ('Lorem ipsum small product 3', 'asdf136', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.', 45, 2, 0, '2021-10-05 12:11:00', true, 2, 120, '{electronics}', '{electronics}', 5, '{/assets/img/product/electronics/5.jpg}', 'Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur.', '400 g', '10 x 10 x 15 cm', '60% cotton, 40% polyester', 'American heirloom jean shorts pug seitan letterpress', '//www.amazon.com');
INSERT INTO public.product (name, sku, "fullDescription", price, vendor_id, discount, "offerEnd", new, rating, "saleCount", category, tag, stock, image, "shortDescription", weight, dimensions, materials, "otherInfo", "affiliateLink") VALUES ('Lorem ipsum small product 2', 'asdf136', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.', 2.5, 2, 5, '2021-10-05 12:11:00', false, 3, 120, '{electronics}', '{electronics}', 0, '{/assets/img/product/electronics/5.jpg}', 'Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur.', '400 g', '10 x 10 x 15 cm', '60% cotton, 40% polyester', 'American heirloom jean shorts pug seitan letterpress', NULL);
INSERT INTO public.product (name, sku, "fullDescription", price, vendor_id, discount, "offerEnd", new, rating, "saleCount", category, tag, stock, image, "shortDescription", weight, dimensions, materials, "otherInfo", "affiliateLink") VALUES ('Lorem ipsum small product 5', 'asdf136', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.', 99, 2, 15, '2021-10-05 12:11:00', true, 1, 120, '{electronics}', '{electronics}', 55, '{/assets/img/product/electronics/5.jpg}', 'Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur.', '400 g', '10 x 10 x 15 cm', '60% cotton, 40% polyester', 'American heirloom jean shorts pug seitan letterpress', NULL);
INSERT INTO public.product (name, sku, "fullDescription", price, vendor_id, discount, "offerEnd", new, rating, "saleCount", category, tag, stock, image, "shortDescription", weight, dimensions, materials, "otherInfo", "affiliateLink") VALUES ('Lorem ipsum small product 4', 'asdf136', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.', 2.5, 2, 5, '2021-10-05 12:11:00', false, 4, 120, '{electronics}', '{electronics}', 23, '{/assets/img/product/electronics/5.jpg}', 'Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur.', '400 g', '10 x 10 x 15 cm', '60% cotton, 40% polyester', 'American heirloom jean shorts pug seitan letterpress', NULL);

INSERT INTO public.shopping_cart_status (status_code, description) VALUES ('open', 'New shopping cart to which is a user is adding items.');
INSERT INTO public.shopping_cart_status (status_code, description) VALUES ('blocked', 'Abandoned shopping cart due to a time out limit.');
INSERT INTO public.shopping_cart_status (status_code, description) VALUES ('checked out', 'Shopping cart was checked out into order.');

INSERT INTO public.order_status_code (status_code, description) VALUES ('Pending', 'Customer started the checkout process but did not complete it.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Awaiting Payment', 'Customer has completed the checkout process, but payment has yet to be confirmed.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Awaiting Fulfillment', 'Customer has completed the checkout process and payment has been confirmed.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Awaiting Shipment', 'Order has been pulled and packaged and is awaiting collection from a shipping provider.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Shipped', 'Order has been shipped, but receipt has not been confirmed.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Completed', 'Order has been shipped, and receipt is confirmed.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Cancelled', 'Seller has cancelled an order, due to a stock inconsistency or other reasons.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Declined', 'Seller has marked the order as declined.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Refunded', 'Seller has refunded the whole order.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Awaiting Payment', 'Customer has completed the checkout process, but payment has yet to be confirmed.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Awaiting Fulfillment', 'Customer has completed the checkout process and payment has been confirmed.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Awaiting Shipment', 'Order has been pulled and packaged and is awaiting collection from a shipping provider.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Shipped', 'Order has been shipped, but receipt has not been confirmed.');
INSERT INTO public.order_status_code (status_code, description) VALUES ('Completed', 'Order has been shipped, and receipt is confirmed.');