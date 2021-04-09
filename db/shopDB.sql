--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.2

-- Started on 2021-04-09 11:29:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16611)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 3124 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 16446)
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(50),
    last_name character varying(150) NOT NULL,
    email_address character varying(200) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    username character varying(200) NOT NULL,
    user_type character(3) NOT NULL
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16532)
-- Name: customer_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.customer_address_id_seq OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16534)
-- Name: customer_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_address (
    address_id integer DEFAULT nextval('public.customer_address_id_seq'::regclass) NOT NULL,
    customer_id integer NOT NULL,
    address_street_no character varying(50) NOT NULL,
    address_street_name character varying(100) NOT NULL,
    address_city character varying(50) NOT NULL,
    address_state character varying(50),
    address_postal_code character varying(25) NOT NULL,
    address_country_code character varying(2) NOT NULL
);


ALTER TABLE public.customer_address OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16444)
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_id_seq OWNER TO postgres;

--
-- TOC entry 3125 (class 0 OID 0)
-- Dependencies: 201
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.customer_id;


--
-- TOC entry 204 (class 1259 OID 16457)
-- Name: customer_login; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_login (
    login_id integer NOT NULL,
    customer_id integer NOT NULL,
    password_hash character varying(256) NOT NULL,
    locked_out boolean DEFAULT false NOT NULL
);


ALTER TABLE public.customer_login OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16455)
-- Name: customer_login_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_login_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_login_id_seq OWNER TO postgres;

--
-- TOC entry 3126 (class 0 OID 0)
-- Dependencies: 203
-- Name: customer_login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_login_id_seq OWNED BY public.customer_login.login_id;


--
-- TOC entry 212 (class 1259 OID 16507)
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    status_code_id integer NOT NULL,
    customer_comments character varying(300),
    created_at timestamp without time zone NOT NULL,
    total numeric DEFAULT 0 NOT NULL
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16505)
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_id_seq OWNER TO postgres;

--
-- TOC entry 3127 (class 0 OID 0)
-- Dependencies: 211
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".order_id;


--
-- TOC entry 214 (class 1259 OID 16515)
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    order_item_id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    final_price numeric NOT NULL
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16513)
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_item_id_seq OWNER TO postgres;

--
-- TOC entry 3128 (class 0 OID 0)
-- Dependencies: 213
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_item_id_seq OWNED BY public.order_item.order_item_id;


--
-- TOC entry 210 (class 1259 OID 16499)
-- Name: order_status_code; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_status_code (
    status_code_id integer NOT NULL,
    status_code character varying(20) NOT NULL,
    description character varying(200) NOT NULL
);


ALTER TABLE public.order_status_code OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16497)
-- Name: order_status_code_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_status_code_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_status_code_id_seq OWNER TO postgres;

--
-- TOC entry 3129 (class 0 OID 0)
-- Dependencies: 209
-- Name: order_status_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_status_code_id_seq OWNED BY public.order_status_code.status_code_id;


--
-- TOC entry 206 (class 1259 OID 16465)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer NOT NULL,
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


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16463)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO postgres;

--
-- TOC entry 3130 (class 0 OID 0)
-- Dependencies: 205
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.product_id;


--
-- TOC entry 208 (class 1259 OID 16487)
-- Name: product_vendor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_vendor (
    vendor_id integer NOT NULL,
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


ALTER TABLE public.product_vendor OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16485)
-- Name: product_vendor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_vendor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_vendor_id_seq OWNER TO postgres;

--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 207
-- Name: product_vendor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_vendor_id_seq OWNED BY public.product_vendor.vendor_id;


--
-- TOC entry 223 (class 1259 OID 16635)
-- Name: shopping_cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shopping_cart (
    cart_id integer NOT NULL,
    customer_id integer NOT NULL,
    status_code_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.shopping_cart OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16633)
-- Name: shopping_cart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shopping_cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_cart_id_seq OWNER TO postgres;

--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 222
-- Name: shopping_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shopping_cart_id_seq OWNED BY public.shopping_cart.cart_id;


--
-- TOC entry 216 (class 1259 OID 16523)
-- Name: shopping_cart_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shopping_cart_item (
    cart_item_id integer NOT NULL,
    cart_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.shopping_cart_item OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16521)
-- Name: shopping_cart_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shopping_cart_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_cart_item_id_seq OWNER TO postgres;

--
-- TOC entry 3133 (class 0 OID 0)
-- Dependencies: 215
-- Name: shopping_cart_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shopping_cart_item_id_seq OWNED BY public.shopping_cart_item.cart_item_id;


--
-- TOC entry 221 (class 1259 OID 16627)
-- Name: shopping_cart_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shopping_cart_status (
    status_code_id integer NOT NULL,
    status_code character varying(20) NOT NULL,
    description character varying(200) NOT NULL
);


ALTER TABLE public.shopping_cart_status OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16625)
-- Name: shopping_cart_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shopping_cart_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_cart_status_id_seq OWNER TO postgres;

--
-- TOC entry 3134 (class 0 OID 0)
-- Dependencies: 220
-- Name: shopping_cart_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shopping_cart_status_id_seq OWNED BY public.shopping_cart_status.status_code_id;


--
-- TOC entry 2923 (class 2604 OID 16449)
-- Name: customer customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN customer_id SET DEFAULT nextval('public.customer_id_seq'::regclass);


--
-- TOC entry 2924 (class 2604 OID 16460)
-- Name: customer_login login_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_login ALTER COLUMN login_id SET DEFAULT nextval('public.customer_login_id_seq'::regclass);


--
-- TOC entry 2934 (class 2604 OID 16510)
-- Name: order order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN order_id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- TOC entry 2936 (class 2604 OID 16518)
-- Name: order_item order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_item_id_seq'::regclass);


--
-- TOC entry 2933 (class 2604 OID 16502)
-- Name: order_status_code status_code_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_code ALTER COLUMN status_code_id SET DEFAULT nextval('public.order_status_code_id_seq'::regclass);


--
-- TOC entry 2926 (class 2604 OID 16468)
-- Name: product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- TOC entry 2932 (class 2604 OID 16490)
-- Name: product_vendor vendor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_vendor ALTER COLUMN vendor_id SET DEFAULT nextval('public.product_vendor_id_seq'::regclass);


--
-- TOC entry 2940 (class 2604 OID 16638)
-- Name: shopping_cart cart_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart ALTER COLUMN cart_id SET DEFAULT nextval('public.shopping_cart_id_seq'::regclass);


--
-- TOC entry 2937 (class 2604 OID 16526)
-- Name: shopping_cart_item cart_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart_item ALTER COLUMN cart_item_id SET DEFAULT nextval('public.shopping_cart_item_id_seq'::regclass);


--
-- TOC entry 2939 (class 2604 OID 16630)
-- Name: shopping_cart_status status_code_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart_status ALTER COLUMN status_code_id SET DEFAULT nextval('public.shopping_cart_status_id_seq'::regclass);


--
-- TOC entry 2970 (class 2606 OID 16541)
-- Name: customer_address customer_address_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 2972 (class 2606 OID 16539)
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (address_id);


--
-- TOC entry 2942 (class 2606 OID 16671)
-- Name: customer customer_email_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_address_key UNIQUE (email_address);


--
-- TOC entry 2948 (class 2606 OID 16543)
-- Name: customer_login customer_login_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_login
    ADD CONSTRAINT customer_login_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 2950 (class 2606 OID 16462)
-- Name: customer_login customer_login_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_login
    ADD CONSTRAINT customer_login_pkey PRIMARY KEY (login_id);


--
-- TOC entry 2944 (class 2606 OID 16454)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 2946 (class 2606 OID 16826)
-- Name: customer customer_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_username_key UNIQUE (username);


--
-- TOC entry 2964 (class 2606 OID 16520)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (order_item_id);


--
-- TOC entry 2960 (class 2606 OID 16512)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- TOC entry 2956 (class 2606 OID 16504)
-- Name: order_status_code order_status_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_code
    ADD CONSTRAINT order_status_code_pkey PRIMARY KEY (status_code_id);


--
-- TOC entry 2952 (class 2606 OID 16473)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 2954 (class 2606 OID 16495)
-- Name: product_vendor product_vendor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_vendor
    ADD CONSTRAINT product_vendor_pkey PRIMARY KEY (vendor_id);


--
-- TOC entry 2974 (class 2606 OID 16632)
-- Name: shopping_cart_status shopping_card_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart_status
    ADD CONSTRAINT shopping_card_status_pkey PRIMARY KEY (status_code_id);


--
-- TOC entry 2968 (class 2606 OID 16528)
-- Name: shopping_cart_item shopping_cart_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart_item
    ADD CONSTRAINT shopping_cart_item_pkey PRIMARY KEY (cart_item_id);


--
-- TOC entry 2976 (class 2606 OID 16640)
-- Name: shopping_cart shopping_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 2957 (class 1259 OID 16575)
-- Name: fki_order_customer_id_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_order_customer_id_fkey ON public."order" USING btree (customer_id);


--
-- TOC entry 2961 (class 1259 OID 16592)
-- Name: fki_order_item_order_id_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_order_item_order_id_fkey ON public.order_item USING btree (order_id);


--
-- TOC entry 2962 (class 1259 OID 16598)
-- Name: fki_order_item_product_id_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_order_item_product_id_fkey ON public.order_item USING btree (product_id);


--
-- TOC entry 2958 (class 1259 OID 16581)
-- Name: fki_order_status_code_id_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_order_status_code_id_fkey ON public."order" USING btree (status_code_id);


--
-- TOC entry 2965 (class 1259 OID 16604)
-- Name: fki_shopping_cart_item_customer_id_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_shopping_cart_item_customer_id_fkey ON public.shopping_cart_item USING btree (cart_id);


--
-- TOC entry 2966 (class 1259 OID 16610)
-- Name: fki_shopping_cart_item_product_id_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_shopping_cart_item_product_id_fkey ON public.shopping_cart_item USING btree (product_id);


--
-- TOC entry 2985 (class 2606 OID 16554)
-- Name: customer_address customer_address_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE CASCADE;


--
-- TOC entry 2977 (class 2606 OID 16549)
-- Name: customer_login customer_login_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_login
    ADD CONSTRAINT customer_login_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE CASCADE;


--
-- TOC entry 2980 (class 2606 OID 16582)
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE SET NULL;


--
-- TOC entry 2981 (class 2606 OID 16587)
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id) ON DELETE RESTRICT;


--
-- TOC entry 2982 (class 2606 OID 16593)
-- Name: order_item order_item_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id) ON DELETE RESTRICT;


--
-- TOC entry 2979 (class 2606 OID 16576)
-- Name: order order_status_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_status_code_id_fkey FOREIGN KEY (status_code_id) REFERENCES public.order_status_code(status_code_id) ON DELETE RESTRICT;


--
-- TOC entry 2978 (class 2606 OID 16565)
-- Name: product product_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.product_vendor(vendor_id) ON DELETE RESTRICT;


--
-- TOC entry 2986 (class 2606 OID 16641)
-- Name: shopping_cart shopping_cart_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE SET NULL;


--
-- TOC entry 2983 (class 2606 OID 16605)
-- Name: shopping_cart_item shopping_cart_item_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart_item
    ADD CONSTRAINT shopping_cart_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id) ON DELETE CASCADE;


--
-- TOC entry 2984 (class 2606 OID 16656)
-- Name: shopping_cart_item shopping_cart_item_shopping_cart_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart_item
    ADD CONSTRAINT shopping_cart_item_shopping_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES public.shopping_cart(cart_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 2987 (class 2606 OID 16646)
-- Name: shopping_cart shopping_cart_status_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_status_code_id_fkey FOREIGN KEY (status_code_id) REFERENCES public.shopping_cart_status(status_code_id) ON DELETE RESTRICT;


-- Completed on 2021-04-09 11:29:12

--
-- PostgreSQL database dump complete
--

