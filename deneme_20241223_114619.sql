--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.0

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
-- Name: add_employee_for_engineer(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_employee_for_engineer() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    -- Insert a new employee record in the Employees table 
    INSERT INTO Employees (FirstName, LastName, Role) 
    VALUES (NEW.FirstName, NEW.LastName, 'Engineer') 
    RETURNING EmployeeID INTO NEW.EmployeeID;  -- Get EmployeeID and assign it to NEW.EmployeeID 

    -- Update the Engineers table with the EmployeeID
    UPDATE Engineers 
    SET EmployeeID = NEW.EmployeeID 
    WHERE EngineerID = NEW.EngineerID; 

    RETURN NEW; 
END; 
$$;


ALTER FUNCTION public.add_employee_for_engineer() OWNER TO postgres;

--
-- Name: add_employee_for_sales(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_employee_for_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    -- Insert a new employee record in the Employees table 
    INSERT INTO Employees (FirstName, LastName, Role) 
    VALUES (NEW.FirstName, NEW.LastName, 'Sales Representative') 
    RETURNING EmployeeID INTO NEW.EmployeeID;  -- Get EmployeeID and assign it to NEW.EmployeeID 

    -- Update the SalesRepresentatives table with the EmployeeID
    UPDATE SalesRepresentatives 
    SET EmployeeID = NEW.EmployeeID 
    WHERE SalesRepID = NEW.SalesRepID; 

    RETURN NEW; 
END; 
$$;


ALTER FUNCTION public.add_employee_for_sales() OWNER TO postgres;

--
-- Name: add_musteri(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_musteri(p_ad character varying, p_soyad character varying, p_telefon character varying DEFAULT NULL::character varying, p_email character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Müşteriler (Ad, Soyad, Telefon, Email)
    VALUES (p_ad, p_soyad, p_telefon, p_email);
END;
$$;


ALTER FUNCTION public.add_musteri(p_ad character varying, p_soyad character varying, p_telefon character varying, p_email character varying) OWNER TO postgres;

--
-- Name: add_personel_for_engineer(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_personel_for_engineer() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Personel tablosuna yeni bir personel kaydı ekle
    INSERT INTO Personeller (Ad, Soyad, Görev)
    VALUES (NEW.Ad, NEW.Soyad, 'Mühendis')
    RETURNING PersonelID INTO NEW.PersonelID;  -- PersonelID'yi al ve NEW.PersonelID'ye ata

    -- Mühendisler tablosunda PersonelID'yi güncelle
    UPDATE Mühendisler
    SET PersonelID = NEW.PersonelID
    WHERE MühendisID = NEW.MühendisID;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_personel_for_engineer() OWNER TO postgres;

--
-- Name: add_personel_for_sales(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_personel_for_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Personel tablosuna yeni bir personel kaydı ekle
    INSERT INTO Personeller (Ad, Soyad, Görev)
    VALUES (NEW.Ad, NEW.Soyad, 'Satış Temsilcisi')
    RETURNING PersonelID INTO NEW.PersonelID;  -- PersonelID'yi al ve NEW.PersonelID'ye ata

    -- Satış Temsilcileri tablosunda PersonelID'yi güncelle
    UPDATE SatisTemsilcileri
    SET PersonelID = NEW.PersonelID
    WHERE SatisTemsilciID = NEW.SatisTemsilciID;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_personel_for_sales() OWNER TO postgres;

--
-- Name: check_part_stock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_part_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    IF NEW.StockQuantity < 0 THEN 
        RAISE EXCEPTION 'Part stock quantity cannot be less than zero!'; 
    END IF; 
    RETURN NEW; 
END; 
$$;


ALTER FUNCTION public.check_part_stock() OWNER TO postgres;

--
-- Name: multiply_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multiply_price() RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE 
    row RECORD;  -- Variable to represent rows
BEGIN 
    -- Multiply the Price of all rows in the Motors table by 30
    FOR row IN 
        SELECT motorid, Price 
        FROM motors 
    LOOP 
        UPDATE motors 
        SET price = row.price * 30 
        WHERE motorid = row.motorid; 
    END LOOP; 
END; 
$$;


ALTER FUNCTION public.multiply_price() OWNER TO postgres;

--
-- Name: quantity_limit_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.quantity_limit_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    -- If quantity is more than 10, raise an exception
    IF NEW.quantity > 10 THEN 
        RAISE EXCEPTION 'Quantity cannot be more than 10'; 
    END IF; 
    RETURN NEW; 
END; 
$$;


ALTER FUNCTION public.quantity_limit_check() OWNER TO postgres;

--
-- Name: update_motor_parts_prices(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_motor_parts_prices() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE MotorParçaları
  SET Fiyat = NEW.Fiyat * 0.8 -- Örnek olarak, motor fiyatının %80'ini parçaların fiyatı olarak alıyoruz
  WHERE MotorID = NEW.MotorID;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_motor_parts_prices() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    categoryid integer NOT NULL,
    categoryname character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_categoryid_seq OWNER TO postgres;

--
-- Name: categories_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_categoryid_seq OWNED BY public.categories.categoryid;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customerid integer NOT NULL,
    firstname character varying(100) NOT NULL,
    lastname character varying(100) NOT NULL,
    phone character varying(15),
    email character varying(100)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_customerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customerid_seq OWNER TO postgres;

--
-- Name: customers_customerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customerid_seq OWNED BY public.customers.customerid;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employeeid integer NOT NULL,
    firstname character varying(100) NOT NULL,
    lastname character varying(100) NOT NULL,
    role character varying(100),
    serviceid integer
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_employeeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employeeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_employeeid_seq OWNER TO postgres;

--
-- Name: employees_employeeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employeeid_seq OWNED BY public.employees.employeeid;


--
-- Name: engineers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.engineers (
    engineerid integer NOT NULL,
    employeeid integer,
    specialization character varying(100) NOT NULL,
    yearsofexperience integer NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    CONSTRAINT engineers_yearsofexperience_check CHECK ((yearsofexperience >= 0))
);


ALTER TABLE public.engineers OWNER TO postgres;

--
-- Name: engineers_engineerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.engineers_engineerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.engineers_engineerid_seq OWNER TO postgres;

--
-- Name: engineers_engineerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.engineers_engineerid_seq OWNED BY public.engineers.engineerid;


--
-- Name: motorparts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motorparts (
    motorid integer NOT NULL,
    partid integer NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT motorparts_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.motorparts OWNER TO postgres;

--
-- Name: motors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motors (
    motorid integer NOT NULL,
    brand character varying(100) NOT NULL,
    model character varying(100) NOT NULL,
    power integer NOT NULL,
    torque integer NOT NULL,
    price numeric(10,2) NOT NULL,
    categoryid integer
);


ALTER TABLE public.motors OWNER TO postgres;

--
-- Name: motors_motorid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motors_motorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.motors_motorid_seq OWNER TO postgres;

--
-- Name: motors_motorid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.motors_motorid_seq OWNED BY public.motors.motorid;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    customerid integer,
    motorid integer,
    orderdate date NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT orders_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_orderid_seq OWNER TO postgres;

--
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- Name: parts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parts (
    partid integer NOT NULL,
    partname character varying(100) NOT NULL,
    stockquantity integer NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT parts_stockquantity_check CHECK ((stockquantity >= 0))
);


ALTER TABLE public.parts OWNER TO postgres;

--
-- Name: parts_partid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parts_partid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parts_partid_seq OWNER TO postgres;

--
-- Name: parts_partid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parts_partid_seq OWNED BY public.parts.partid;


--
-- Name: salesrepresentatives; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salesrepresentatives (
    salesrepid integer NOT NULL,
    employeeid integer,
    salestarget numeric(10,2) NOT NULL,
    region character varying(100) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    CONSTRAINT salesrepresentatives_salestarget_check CHECK ((salestarget >= (0)::numeric))
);


ALTER TABLE public.salesrepresentatives OWNER TO postgres;

--
-- Name: salesrepresentatives_salesrepid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salesrepresentatives_salesrepid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salesrepresentatives_salesrepid_seq OWNER TO postgres;

--
-- Name: salesrepresentatives_salesrepid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salesrepresentatives_salesrepid_seq OWNED BY public.salesrepresentatives.salesrepid;


--
-- Name: serviceinvoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serviceinvoices (
    invoiceid integer NOT NULL,
    recordid integer,
    totalamount numeric(10,2) NOT NULL
);


ALTER TABLE public.serviceinvoices OWNER TO postgres;

--
-- Name: serviceinvoices_invoiceid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serviceinvoices_invoiceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serviceinvoices_invoiceid_seq OWNER TO postgres;

--
-- Name: serviceinvoices_invoiceid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serviceinvoices_invoiceid_seq OWNED BY public.serviceinvoices.invoiceid;


--
-- Name: servicerecords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicerecords (
    recordid integer NOT NULL,
    motorid integer,
    serviceid integer,
    servicedate date NOT NULL,
    description text
);


ALTER TABLE public.servicerecords OWNER TO postgres;

--
-- Name: servicerecords_recordid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servicerecords_recordid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servicerecords_recordid_seq OWNER TO postgres;

--
-- Name: servicerecords_recordid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servicerecords_recordid_seq OWNED BY public.servicerecords.recordid;


--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    serviceid integer NOT NULL,
    servicename character varying(100) NOT NULL,
    location character varying(255) NOT NULL
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: services_serviceid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_serviceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_serviceid_seq OWNER TO postgres;

--
-- Name: services_serviceid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_serviceid_seq OWNED BY public.services.serviceid;


--
-- Name: categories categoryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN categoryid SET DEFAULT nextval('public.categories_categoryid_seq'::regclass);


--
-- Name: customers customerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customerid SET DEFAULT nextval('public.customers_customerid_seq'::regclass);


--
-- Name: employees employeeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employeeid SET DEFAULT nextval('public.employees_employeeid_seq'::regclass);


--
-- Name: engineers engineerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engineers ALTER COLUMN engineerid SET DEFAULT nextval('public.engineers_engineerid_seq'::regclass);


--
-- Name: motors motorid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motors ALTER COLUMN motorid SET DEFAULT nextval('public.motors_motorid_seq'::regclass);


--
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- Name: parts partid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parts ALTER COLUMN partid SET DEFAULT nextval('public.parts_partid_seq'::regclass);


--
-- Name: salesrepresentatives salesrepid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salesrepresentatives ALTER COLUMN salesrepid SET DEFAULT nextval('public.salesrepresentatives_salesrepid_seq'::regclass);


--
-- Name: serviceinvoices invoiceid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceinvoices ALTER COLUMN invoiceid SET DEFAULT nextval('public.serviceinvoices_invoiceid_seq'::regclass);


--
-- Name: servicerecords recordid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicerecords ALTER COLUMN recordid SET DEFAULT nextval('public.servicerecords_recordid_seq'::regclass);


--
-- Name: services serviceid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN serviceid SET DEFAULT nextval('public.services_serviceid_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories VALUES
	(1, 'Electric Motors'),
	(2, 'Gasoline Motors'),
	(3, 'Diesel Motors');


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES
	(1, 'Ahmet', 'Yılmaz', '5551234567', 'ahmet.yilmaz@example.com'),
	(2, 'Ayşe', 'Demir', '5559876543', 'ayse.demir@example.com'),
	(3, 'Mehmet', 'Kara', '5558765432', 'mehmet.kara@example.com');


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employees VALUES
	(1, 'Ali', 'Çelik', 'Technician', 1),
	(2, 'Fatma', 'Kaya', 'Service Manager', 2),
	(3, 'Can', 'Ersoy', 'Manager', NULL),
	(4, 'Ali', 'Çelik', 'Engineer', NULL),
	(5, 'Fatma', 'Kaya', 'Engineer', NULL),
	(6, 'Can', 'Ersoy', 'Sales Representative', NULL),
	(8, 'Serdar', 'Sina', 'Engineer', NULL);


--
-- Data for Name: engineers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.engineers VALUES
	(1, 4, 'Electrical Engineering', 5, 'Ali', 'Çelik'),
	(2, 5, 'Mechanical Engineering', 10, 'Fatma', 'Kaya'),
	(4, 8, 'Computer Engineering', 8, 'Serdar', 'Sina');


--
-- Data for Name: motorparts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.motorparts VALUES
	(1, 1, 2),
	(2, 2, 1),
	(3, 3, 4);


--
-- Data for Name: motors; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.motors VALUES
	(1, 'Yamaha', 'YZF-R1', 200, 112, 25000.00, 2),
	(2, 'Tesla', 'Model X Motor', 300, 500, 45000.00, 1),
	(3, 'Kawasaki', 'Ninja ZX-10R', 210, 114, 27000.00, 2);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orders VALUES
	(1, 1, 1, '2024-12-01', 2),
	(2, 2, 2, '2024-12-05', 1),
	(3, 3, 3, '2024-12-10', 3);


--
-- Data for Name: parts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.parts VALUES
	(1, 'Brake Disc', 50, 100.00),
	(2, 'Battery', 20, 500.00),
	(3, 'Tire', 100, 200.00);


--
-- Data for Name: salesrepresentatives; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.salesrepresentatives VALUES
	(1, 6, 50000.00, 'Marmara', 'Can', 'Ersoy');


--
-- Data for Name: serviceinvoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.serviceinvoices VALUES
	(1, 1, 300.00),
	(2, 2, 1500.00),
	(3, 3, 1000.00);


--
-- Data for Name: servicerecords; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.servicerecords VALUES
	(1, 1, 1, '2024-12-15', 'Engine oil changed.'),
	(2, 2, 2, '2024-12-16', 'Battery check performed.'),
	(3, 3, 3, '2024-12-17', 'General maintenance performed.');


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.services VALUES
	(1, 'Istanbul Service', 'Istanbul'),
	(2, 'Ankara Service', 'Ankara'),
	(3, 'Izmir Service', 'Izmir');


--
-- Name: categories_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_categoryid_seq', 3, true);


--
-- Name: customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customerid_seq', 3, true);


--
-- Name: employees_employeeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employeeid_seq', 8, true);


--
-- Name: engineers_engineerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.engineers_engineerid_seq', 4, true);


--
-- Name: motors_motorid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.motors_motorid_seq', 3, true);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 3, true);


--
-- Name: parts_partid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parts_partid_seq', 3, true);


--
-- Name: salesrepresentatives_salesrepid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salesrepresentatives_salesrepid_seq', 1, true);


--
-- Name: serviceinvoices_invoiceid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serviceinvoices_invoiceid_seq', 3, true);


--
-- Name: servicerecords_recordid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servicerecords_recordid_seq', 3, true);


--
-- Name: services_serviceid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_serviceid_seq', 3, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (categoryid);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customerid);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employeeid);


--
-- Name: engineers engineers_employeeid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_employeeid_key UNIQUE (employeeid);


--
-- Name: engineers engineers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_pkey PRIMARY KEY (engineerid);


--
-- Name: motorparts motorparts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorparts
    ADD CONSTRAINT motorparts_pkey PRIMARY KEY (motorid, partid);


--
-- Name: motors motors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motors
    ADD CONSTRAINT motors_pkey PRIMARY KEY (motorid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: parts parts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parts
    ADD CONSTRAINT parts_pkey PRIMARY KEY (partid);


--
-- Name: salesrepresentatives salesrepresentatives_employeeid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salesrepresentatives
    ADD CONSTRAINT salesrepresentatives_employeeid_key UNIQUE (employeeid);


--
-- Name: salesrepresentatives salesrepresentatives_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salesrepresentatives
    ADD CONSTRAINT salesrepresentatives_pkey PRIMARY KEY (salesrepid);


--
-- Name: serviceinvoices serviceinvoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceinvoices
    ADD CONSTRAINT serviceinvoices_pkey PRIMARY KEY (invoiceid);


--
-- Name: servicerecords servicerecords_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicerecords
    ADD CONSTRAINT servicerecords_pkey PRIMARY KEY (recordid);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (serviceid);


--
-- Name: orders check_quantity_limit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_quantity_limit BEFORE INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.quantity_limit_check();


--
-- Name: engineers trg_add_employee_for_engineer; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_add_employee_for_engineer AFTER INSERT ON public.engineers FOR EACH ROW EXECUTE FUNCTION public.add_employee_for_engineer();


--
-- Name: salesrepresentatives trg_sales_to_employee; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sales_to_employee AFTER INSERT ON public.salesrepresentatives FOR EACH ROW EXECUTE FUNCTION public.add_employee_for_sales();


--
-- Name: parts trigger_check_part_stock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_check_part_stock BEFORE INSERT OR UPDATE ON public.parts FOR EACH ROW EXECUTE FUNCTION public.check_part_stock();


--
-- Name: employees employees_serviceid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_serviceid_fkey FOREIGN KEY (serviceid) REFERENCES public.services(serviceid) ON DELETE SET NULL;


--
-- Name: engineers engineers_employeeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_employeeid_fkey FOREIGN KEY (employeeid) REFERENCES public.employees(employeeid) ON DELETE CASCADE;


--
-- Name: motorparts motorparts_motorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorparts
    ADD CONSTRAINT motorparts_motorid_fkey FOREIGN KEY (motorid) REFERENCES public.motors(motorid) ON DELETE CASCADE;


--
-- Name: motorparts motorparts_partid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motorparts
    ADD CONSTRAINT motorparts_partid_fkey FOREIGN KEY (partid) REFERENCES public.parts(partid) ON DELETE CASCADE;


--
-- Name: motors motors_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motors
    ADD CONSTRAINT motors_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.categories(categoryid) ON DELETE SET NULL;


--
-- Name: orders orders_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customers(customerid) ON DELETE CASCADE;


--
-- Name: orders orders_motorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_motorid_fkey FOREIGN KEY (motorid) REFERENCES public.motors(motorid) ON DELETE CASCADE;


--
-- Name: salesrepresentatives salesrepresentatives_employeeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salesrepresentatives
    ADD CONSTRAINT salesrepresentatives_employeeid_fkey FOREIGN KEY (employeeid) REFERENCES public.employees(employeeid) ON DELETE CASCADE;


--
-- Name: serviceinvoices serviceinvoices_recordid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceinvoices
    ADD CONSTRAINT serviceinvoices_recordid_fkey FOREIGN KEY (recordid) REFERENCES public.servicerecords(recordid) ON DELETE CASCADE;


--
-- Name: servicerecords servicerecords_motorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicerecords
    ADD CONSTRAINT servicerecords_motorid_fkey FOREIGN KEY (motorid) REFERENCES public.motors(motorid) ON DELETE CASCADE;


--
-- Name: servicerecords servicerecords_serviceid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicerecords
    ADD CONSTRAINT servicerecords_serviceid_fkey FOREIGN KEY (serviceid) REFERENCES public.services(serviceid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

