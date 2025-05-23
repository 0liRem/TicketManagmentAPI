PGDMP  5                    }            Tickets    17.3    17.2     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    17432    Tickets    DATABASE     o   CREATE DATABASE "Tickets" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';
    DROP DATABASE "Tickets";
                     postgres    false            �            1259    17434 	   incidents    TABLE     5  CREATE TABLE public.incidents (
    id integer NOT NULL,
    reporter character varying(100) NOT NULL,
    description text NOT NULL,
    status character varying(20) DEFAULT 'pendiente'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id integer,
    CONSTRAINT chk_description_length CHECK ((length(description) >= 10)),
    CONSTRAINT chk_status CHECK (((status)::text = ANY ((ARRAY['pendiente'::character varying, 'en proceso'::character varying, 'resuelto'::character varying])::text[])))
);
    DROP TABLE public.incidents;
       public         heap r       postgres    false            �            1259    17433    incidents_id_seq    SEQUENCE     �   CREATE SEQUENCE public.incidents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.incidents_id_seq;
       public               postgres    false    218            �           0    0    incidents_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.incidents_id_seq OWNED BY public.incidents.id;
          public               postgres    false    217            �            1259    17449    users    TABLE     >  CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    17448    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public               postgres    false    220            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public               postgres    false    219            &           2604    17437    incidents id    DEFAULT     l   ALTER TABLE ONLY public.incidents ALTER COLUMN id SET DEFAULT nextval('public.incidents_id_seq'::regclass);
 ;   ALTER TABLE public.incidents ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    218    217    218            )           2604    17452    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    220    219    220            �          0    17434 	   incidents 
   TABLE DATA           [   COPY public.incidents (id, reporter, description, status, created_at, user_id) FROM stdin;
    public               postgres    false    218   �       �          0    17449    users 
   TABLE DATA           Z   COPY public.users (id, username, email, password_hash, created_at, is_active) FROM stdin;
    public               postgres    false    220   :       �           0    0    incidents_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.incidents_id_seq', 2, true);
          public               postgres    false    217            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 1, false);
          public               postgres    false    219            1           2606    17445    incidents incidents_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.incidents DROP CONSTRAINT incidents_pkey;
       public                 postgres    false    218            3           2606    17460    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public                 postgres    false    220            5           2606    17456    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    220            7           2606    17458    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public                 postgres    false    220            .           1259    17447    idx_incidents_created_at    INDEX     T   CREATE INDEX idx_incidents_created_at ON public.incidents USING btree (created_at);
 ,   DROP INDEX public.idx_incidents_created_at;
       public                 postgres    false    218            /           1259    17446    idx_incidents_status    INDEX     L   CREATE INDEX idx_incidents_status ON public.incidents USING btree (status);
 (   DROP INDEX public.idx_incidents_status;
       public                 postgres    false    218            8           2606    17461     incidents incidents_user_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.incidents DROP CONSTRAINT incidents_user_id_fkey;
       public               postgres    false    218    220    4661            �   j   x��1
�0 �9}E>P	�����������Ҋ�?�~L�n9�ާ-f�;�^0l�5��Ą������/��I��	�Y5
L\Yr�$�\ۑ+���K�'3Ƙ��      �      x������ � �     