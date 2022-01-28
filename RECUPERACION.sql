/*==============================================================*/
/* Table: ALQUILER                                              */
/*==============================================================*/
create table ALQUILER (
   IDALQUILER           INT4                 not null,
   IDCLIENTE            INT4                 null,
   IDPELICULA           INT4                 null,
   FECHAPRESTAMO        DATE                 not null,
   FECHAENTREGA         DATE                 not null,
   VALOR                NUMERIC(8,2)         not null,--INCREMENT
   constraint PK_ALQUILER primary key (IDALQUILER)
);

/*==============================================================*/
/* Index: ALQUILER_PK                                           */
/*==============================================================*/
create unique index ALQUILER_PK on ALQUILER (
IDALQUILER
);

/*==============================================================*/
/* Index: CLIENTE_ALQUILER_FK                                   */
/*==============================================================*/
create  index CLIENTE_ALQUILER_FK on ALQUILER (
IDCLIENTE
);

/*==============================================================*/
/* Index: PELICULA_ALQUILER_FK                                  */
/*==============================================================*/
create  index PELICULA_ALQUILER_FK on ALQUILER (
IDPELICULA
);

/*==============================================================*/
/* Table: CLIENTE                                               */
/*==============================================================*/
create table CLIENTE (
   IDCLIENTE            INT4                 not null,
   CEDULACLIENTE        VARCHAR(10)          not null,
   NOMBRECLIENTE        VARCHAR(20)          not null,
   APELLIDOCLIENTE      VARCHAR(20)          not null,
   FECHAREGISTROCLIENTE DATE                 not null,
   constraint PK_CLIENTE primary key (IDCLIENTE)
);

/*==============================================================*/
/* Index: CLIENTE_PK                                            */
/*==============================================================*/
create unique index CLIENTE_PK on CLIENTE (
IDCLIENTE
);

/*==============================================================*/
/* Table: PELICULA                                              */
/*==============================================================*/
create table PELICULA (
   IDPELICULA           INT4                 not null,
   NOMBREPELICULA       VARCHAR(30)          not null,
   ANO_ESTRENO           INT4                 not null,
   constraint PK_PELICULA primary key (IDPELICULA)
);

/*==============================================================*/
/* Index: PELICULA_PK                                           */
/*==============================================================*/
create unique index PELICULA_PK on PELICULA (
IDPELICULA
);

alter table ALQUILER
   add constraint FK_ALQUILER_CLIENTE_A_CLIENTE foreign key (IDCLIENTE)
      references CLIENTE (IDCLIENTE)
      on delete restrict on update restrict;

alter table ALQUILER
   add constraint FK_ALQUILER_PELICULA__PELICULA foreign key (IDPELICULA)
      references PELICULA (IDPELICULA)
      on delete restrict on update restrict;



/////inserciones////

/*==============================================================*/
/* INSERTAR DATOS: CLIENTE                                               */
/*==============================================================*/
INSERT INTO cliente 
VALUES (1,'1309865741','Pedro','Lucas','5/10/2019');
INSERT INTO CLIENTE 
VALUES (2,'1319687451','Maria', 'Mendoza','9/5/2020');

/*==============================================================*/
/* INSERTAR DATOS: PELICULA                                     */
/*==============================================================*/ 
INSERT INTO PELICULA VALUES(1,'Por un nuevo amanecer',2020);
INSERT INTO PELICULA VALUES(2,'Crudas pero buenas',2018);
INSERT INTO PELICULA VALUES(3,'Buenas y Cachondas',2021);
INSERT INTO PELICULA VALUES(4,'El Scrim',2022);
	   
/*==============================================================*/
/* INSERTAR DATOS: ALQUILER                                     */
/*==============================================================*/
INSERT INTO ALQUILER VALUES(1,1,1,'5/5/2021','7/5/2021',5);
INSERT INTO ALQUILER VALUES(2,2,2,'10/8/2021','12/8/2021',2);


////trigger/////

CREATE OR REPLACE FUNCTION tr_pelicula() RETURNS TRIGGER
AS 
$tr_pelicula$
	DECLARE
		nentrega int;
		fecha_entrega date;	
BEGIN 
select count (*) into nentrega  from cliente where id_cliente = new.id_cliente;
select alquiler.id_cliente into fecha_entrega from alquiler;
NEW.valor_alquiler := NEW.valor_alquiler + fecha_entrega;

	if (fecha_entrega >= nentrega)
	then
	RAISE NOTICE 'Se le incremento el precio del dia de alquiler al dia de entrega';
	END if;
	RETURN new;
END;
$tr_pelicula$
LANGUAGE plpgsql;

create trigger alquiler before insert or update
on alquiler for EACH ROW
execute procedure alquiler();


--INSERTAMOS DATOS PARA VERIFICAR EN EL TRIGGER
insert into ALQUILER VALUES(2,1,3,'17/08/2021','18/08/2021',6);