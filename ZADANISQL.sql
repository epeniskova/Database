/*==============================================================*/
/* DBMS name:      ORACLE Version 10g                           */
/* Created on:     13. 5. 2018 13:04:32                         */
/*==============================================================*/


alter table FYZICKY_SERVER
   drop constraint FK_FYZICKY__TYP_SLUZB_SLUZBA;

alter table MONITORING
   drop constraint FK_MONITORI_MONITORIN_ZAM;

alter table MONITORING
   drop constraint FK_MONITORI_MONITORIN_SLUZBA;

alter table TICKET
   drop constraint FK_TICKET_PRIRAZEN_SLUZBA;

alter table TICKET
   drop constraint FK_TICKET_RESI_ZAM;

alter table TICKET
   drop constraint FK_TICKET_ZAKLADA_KLIENT;

alter table VIRTUALNI_SERVER
   drop constraint FK_VIRTUALN_TYP_SLUZB_SLUZBA;

drop table FYZICKY_SERVER cascade constraints;

drop table KLIENT cascade constraints;

drop index MONITORING2_FK;

drop index MONITORING_FK;

drop table MONITORING cascade constraints;

drop table SLUZBA cascade constraints;

drop index ZAKLADA_FK;

drop index PRIRAZEN_FK;

drop index RESI_FK;

drop table TICKET cascade constraints;

drop table VIRTUALNI_SERVER cascade constraints;

drop table ZAM cascade constraints;

/*==============================================================*/
/* Table: FYZICKY_SERVER                                        */
/*==============================================================*/
create table FYZICKY_SERVER  (
   OZ_SLUZ              VARCHAR2(20)                    not null,
   IPV4                 VARCHAR2(30)                    not null,
   IPV6                 VARCHAR2(30),
   NAPAJENI             VARCHAR2(10),
   TYP_SERVERU          VARCHAR2(30)                   
      constraint CKC_TYP_SERVERU_FYZICKY_ check (TYP_SERVERU is null or (TYP_SERVERU in ('DCH','CH','DCF','CF','CR'))),
   constraint PK_FYZICKY_SERVER primary key (OZ_SLUZ)
);

/*==============================================================*/
/* Table: KLIENT                                                */
/*==============================================================*/
create table KLIENT  (
   ICO                  NUMBER(15)                      not null,
   NAZEV_SPOLEC         VARCHAR2(40)                    not null,
   EMAIL                VARCHAR2(50)                    not null
      constraint CKC_EMAIL_KLIENT check (EMAIL in ('like ''%_@__%.__%''')),
   TELEFON              NUMBER(12),
   ULICE                VARCHAR2(20)                    not null,
   CIS_POPIS            NUMBER(10)                      not null,
   MESTO                VARCHAR2(20)                    not null,
   PSC                  NUMBER(5)                       not null,
   constraint PK_KLIENT primary key (ICO)
);

/*==============================================================*/
/* Table: MONITORING                                            */
/*==============================================================*/
create table MONITORING  (
   LOGIN                VARCHAR2(50)                    not null
      constraint CKC_LOGIN_MONITORI check (LOGIN in ('like ''%.%''')),
   OZ_SLUZ              VARCHAR2(20)                    not null
      constraint CKC_OZ_SLUZ_MONITORI check (OZ_SLUZ in ('like ''%/%''')),
   constraint PK_MONITORING primary key (LOGIN, OZ_SLUZ)
);

/*==============================================================*/
/* Index: MONITORING_FK                                         */
/*==============================================================*/
create index MONITORING_FK on MONITORING (
   LOGIN ASC
);

/*==============================================================*/
/* Index: MONITORING2_FK                                        */
/*==============================================================*/
create index MONITORING2_FK on MONITORING (
   OZ_SLUZ ASC
);

/*==============================================================*/
/* Table: SLUZBA                                                */
/*==============================================================*/
create table SLUZBA  (
   OZ_SLUZ              VARCHAR2(20)                    not null
      constraint CKC_OZ_SLUZ_SLUZBA check (OZ_SLUZ in ('like ''%/%''')),
   IPV4                 VARCHAR2(30)                    not null,
   IPV6                 VARCHAR2(30),
   NAPAJENI             VARCHAR2(10),
   constraint PK_SLUZBA primary key (OZ_SLUZ)
);

/*==============================================================*/
/* Table: TICKET                                                */
/*==============================================================*/
create table TICKET  (
   PORAD_CIS            VARCHAR2(12)                    not null,
   RESITEL              VARCHAR2(50),
   OZ_SLUZ              VARCHAR2(20)                    not null,
   ICO_ZADAVATELE       NUMBER(15)                      not null,
   NAZEV                VARCHAR2(40)                    not null,
   POPIS                VARCHAR2(300)                   not null,
   PRIORITA             VARCHAR2(50)                   
      constraint CKC_PRIORITA_TICKET check (PRIORITA is null or (PRIORITA in ('NIZKA','STREDNI','VYSOKA'))),
   STAV                 VARCHAR2(50)                    not null
      constraint CKC_STAV_TICKET check (STAV in ('NOVY','OTEVRENY','VYRESENY','ODLOZENY')),
   constraint PK_TICKET primary key (PORAD_CIS)
);

/*==============================================================*/
/* Index: RESI_FK                                               */
/*==============================================================*/
create index RESI_FK on TICKET (
   RESITEL ASC
);

/*==============================================================*/
/* Index: PRIRAZEN_FK                                           */
/*==============================================================*/
create index PRIRAZEN_FK on TICKET (
   OZ_SLUZ ASC
);

/*==============================================================*/
/* Index: ZAKLADA_FK                                            */
/*==============================================================*/
create index ZAKLADA_FK on TICKET (
   ICO_ZADAVATELE ASC
);

/*==============================================================*/
/* Table: VIRTUALNI_SERVER                                      */
/*==============================================================*/
create table VIRTUALNI_SERVER  (
   OZ_SLUZ              VARCHAR2(20)                    not null,
   IPV4                 VARCHAR2(30)                    not null,
   IPV6                 VARCHAR2(30),
   NAPAJENI             VARCHAR2(10),
   TYP_SER              VARCHAR2(20)                    not null
      constraint CKC_TYP_SER_VIRTUALN check (TYP_SER in ('VS_WINDOWS','VS_LINUX')),
   constraint PK_VIRTUALNI_SERVER primary key (OZ_SLUZ)
);

/*==============================================================*/
/* Table: ZAM                                                   */
/*==============================================================*/
create table ZAM  (
   LOGIN                VARCHAR2(50)                    not null
      constraint CKC_LOGIN_ZAM check (LOGIN in ('like ''%.%''')),
   JMENO                VARCHAR2(30)                    not null,
   PRIJMENI             VARCHAR2(40)                    not null,
   TELEFON              NUMBER(12),
   EMAIL                VARCHAR2(50)                    not null
      constraint CKC_EMAIL_ZAM check (EMAIL in ('email like ''%_@__%.__%''')),
   constraint PK_ZAM primary key (LOGIN)
);

alter table FYZICKY_SERVER
   add constraint FK_FYZICKY__TYP_SLUZB_SLUZBA foreign key (OZ_SLUZ)
      references SLUZBA (OZ_SLUZ)
      on delete cascade;

alter table MONITORING
   add constraint FK_MONITORI_MONITORIN_ZAM foreign key (LOGIN)
      references ZAM (LOGIN)
      on delete cascade;

alter table MONITORING
   add constraint FK_MONITORI_MONITORIN_SLUZBA foreign key (OZ_SLUZ)
      references SLUZBA (OZ_SLUZ)
      on delete cascade;

alter table TICKET
   add constraint FK_TICKET_PRIRAZEN_SLUZBA foreign key (OZ_SLUZ)
      references SLUZBA (OZ_SLUZ)
      on delete cascade;

alter table TICKET
   add constraint FK_TICKET_RESI_ZAM foreign key (RESITEL)
      references ZAM (LOGIN)
      on delete set null;

alter table TICKET
   add constraint FK_TICKET_ZAKLADA_KLIENT foreign key (ICO_ZADAVATELE)
      references KLIENT (ICO)
      on delete cascade;

alter table VIRTUALNI_SERVER
   add constraint FK_VIRTUALN_TYP_SLUZB_SLUZBA foreign key (OZ_SLUZ)
      references SLUZBA (OZ_SLUZ)
      on delete cascade;

