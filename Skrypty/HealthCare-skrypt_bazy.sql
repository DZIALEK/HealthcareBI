USE [master];
--USE [HealthcareBI];
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'testowaDB')
BEGIN
    DROP DATABASE testowaDB;  
END;
	CREATE DATABASE testowaDB;
GO
	USE testowaDB
GO

----------------------
--SELECT
--	QUOTENAME(DB_NAME(database_id))   
--    + N'.'   
--    + QUOTENAME(OBJECT_SCHEMA_NAME(object_id, database_id))   
--    + N'.'   
--    + QUOTENAME(OBJECT_NAME(object_id, database_id))  
--    , *   
--FROM sys.dm_db_index_operational_stats(null, null, null, null)
--WHERE 1=1
--	AND OBJECT_SCHEMA_NAME(	object_id, database_id) = 'Integration'
--	--DB_NAME NOT IN ('msdb', 'master', 'tempdb', 'Lab', 'lab2', 'Lab_wzorcowy','WideWorldImporters', 'WideWorldImportersDW')
--	--AND OBJECT_SCHEMA_NAME NOT IN ('sys')
--	;  
--GO  

-- select * from sys.schemas
-----------------------------------------------
/* Tworzy schematy na bazie                */
-----------------------------------------------

IF EXISTS (SELECT name
		FROM sys.schemas
		WHERE 
			name = N'Integration'
			)
   BEGIN
      DROP SCHEMA Integration
END
GO
CREATE SCHEMA Integration
GO

IF EXISTS (SELECT name
		FROM sys.schemas
		WHERE 
			name = N'Dimension'
			)
   BEGIN
      DROP SCHEMA Dimension
END
GO
CREATE SCHEMA Dimension
GO

IF EXISTS (SELECT name
		FROM sys.schemas
		WHERE 
			name = N'Fact'
			)
   BEGIN
      DROP SCHEMA Fact
END
GO
CREATE SCHEMA Fact
GO



---------------------------------------------------
/* --Sprawdzenie czy utworzy³y siê schematy      */
---------------------------------------------------

--SELECT 
--    s.name AS schema_name, 
--    u.name AS schema_owner
--FROM 
--    sys.schemas s
--INNER JOIN sys.sysusers u ON u.uid = s.principal_id
--ORDER BY 
--    s.name;



-----------------------------------------------
/* Tworzenie tabeli schematu INTEGRATION    */
-----------------------------------------------

CREATE TABLE Integration.TrybWypisuStaging
	(
	IDStaging smallint identity (1,1) CONSTRAINT PK_TrybWypisuStaging PRIMARY KEY,
	KSGL_TRYN varchar(2),
	TRYB varchar(100),
	TRYB_GRUPA varchar(30),
	DataImportu SMALLDATETIME NOT NULL DEFAULT GETDATE()
	);
GO


CREATE TABLE Integration.HospitalizacjaStaging
	(
	IDStaging int identity(1,1) CONSTRAINT PK_HospitalizacjaStaging PRIMARY KEY,
	DataImportu SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	LP varchar(10),
	KSGL_DATP varchar(50),
	KSGL_DATW varchar(50),
	KSGL_RDKS varchar(2),
	KSGL_ROKM varchar(4),
	KSGL_TRYW varchar(2),
	KSGL_TRYN varchar(2),
	KSOD_DPZW varchar(50),
	KSOD_TRYW varchar(2),
	KSOD_DATP varchar(50),
	KSOD_DATW varchar(50),
	INSTA_PACJ_ID varchar(15),
	HASH_PESL varchar(50),
	PACJ_PLEC varchar(1) ,
	JNIP_NAZW varchar(100),
	NZMI      varchar(200),
	PCRZ_ICDR varchar(10),
	PCRZ_OPIS varchar(255),
	PCRZ_STAN varchar(10),
	PCRZ_TYPT varchar(3),
	ROZP_ICDR varchar(10),
	ROZP_NAZW varchar(20),
	OSOBODNI  varchar(5),
	SUMA_ICD9 varchar(5),
	ODDZIAL   varchar(100),
	ADRES_PODMIOTU varchar(100)
	);
GO


CREATE TABLE Integration.AnkietaDBStaging
	(
	IDStaging int identity(1,1) CONSTRAINT PK_AnkietaDBStaging PRIMARY KEY,
	DataImportu SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	[Godzina rozpoczecia] varchar(30),
	[Godzina ukonczenia] varchar(30),
	[Adres e-mail] varchar(30),
	[Jakiego miesiaca dotycza sprawozdawane dane] varchar(30),
	[Jakiego roku dotycza sprawozdawane dane] varchar(4),
	[Wybierz rodzaj placowki] varchar(50),
	[Wybierz szpital wieloprofilowy] varchar(100),
	[Wybierz monoklinike] varchar(200),
	[Czy_zebrano_ankiety] varchar(3),
	[Uzasadnij dlaczego nie uda³o siê zebraæ ani jednej ankiety?] ntext,
	[Ile_pacjentow_mezczyzn] varchar(5),
	[Ile_pacjentow_kobiet] varchar(5),
	[Ile_pacjentow_wiek18-29] varchar(5),
	[Ile_pacjentow_wiek30-39] varchar(5),
	[Ile_pacjentow_wiek40-49] varchar(5),
	[Ile_pacjentow_wiek50-69] varchar(5),
	[Ile_pacjentow_wiek_powyzej70] varchar(5),
	[Ile_pacjentow_wyksztalcenie_podstawowe] varchar(5), 
	[Ile_pacjentow_wyksztalcenie_srednie] varchar(5),
	[Ile_pacjentow_wyksztalcenie_wyzsze] varchar(5),	
	[Czas oczekiwania zwi¹zanego z przyjêciem do Szpitala (szybkoœæ za³atwienia formalnoœci)_ZD] varchar(5),
	[Czas oczekiwania zwi¹zanego z przyjêciem do Szpitala (szybkoœæ za³atwienia formalnoœci)_RD] varchar(5),
	[Czas oczekiwania zwi¹zanego z przyjêciem do Szpitala (szybkoœæ za³atwienia formalnoœci)_RZ] varchar(5),
	[Czas oczekiwania zwi¹zanego z przyjêciem do Szpitala (szybkoœæ za³atwienia formalnoœci)_ZZ] varchar(5),
	[Czas oczekiwania zwi¹zanego z przyjêciem do Szpitala (szybkoœæ za³atwienia formalnoœci)_ND] varchar(5),
	[Organizacja sposobu przyjêcia do Szpitala_ZD] varchar(5),
	[Organizacja sposobu przyjêcia do Szpitala_RD] varchar(5),
	[Organizacja sposobu przyjêcia do Szpitala_RZ] varchar(5), 
	[Organizacja sposobu przyjêcia do Szpitala_ZZ] varchar(5),
	[Organizacja sposobu przyjêcia do Szpitala_ND] varchar(5),
	[Czy poleci³/³aby Pan/Pani nasz Szpital swojej rodzinie, przyjacio³om lub znajomym?_ZT] varchar(5),
	[Czy poleci³/³aby Pan/Pani nasz Szpital swojej rodzinie, przyjacio³om lub znajomym?_RT] varchar(5),
	[Czy poleci³/³aby Pan/Pani nasz Szpital swojej rodzinie, przyjacio³om lub znajomym?_RN] varchar(5),
	[Czy poleci³/³aby Pan/Pani nasz Szpital swojej rodzinie, przyjacio³om lub znajomym?_ZN] varchar(5),	
	);
 GO



---------------------------------------------------
/* Tworzenie tabeli schematu DIMENSION i relacji */
---------------------------------------------------

BEGIN
		DECLARE @StartDate  date = '20160101';
		DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 20, @StartDate));
		;WITH seq(n) AS 
		(
			SELECT 0 UNION ALL SELECT n + 1 FROM seq
			WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
		),
		d(d) AS 
		(
			SELECT DATEADD(DAY, n, @StartDate) FROM seq
		),
		src AS
		(
			SELECT
			IDData          = CONVERT(date, d),
			DzienNr          = DATEPART(DAY,       d),
			DzienNazwa      = DATENAME(WEEKDAY,   d),
			TydzienRoku         = DATEPART(WEEK,      d),
			TydzienRokuISO      = DATEPART(ISO_WEEK,  d),
			DzienTygodnia    = DATEPART(WEEKDAY,   d),
			MiesiacNr        = DATEPART(MONTH,     d),
			MiesiacNazwa    = DATENAME(MONTH,     d),
			Kwartal      = DATEPART(Quarter,   d),
			Rok         = DATEPART(YEAR,      d),
			PierwszyDzienMiesiaca = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
	 		OstatniDzienMiesiaca = DATEADD(DAY,-1,(DATEADD(MONTH,+1,DATEFROMPARTS(YEAR(d), MONTH(d), 1)))),
			OstatniDzienRoku   = DATEFROMPARTS(YEAR(d), 12, 31),
			DzienRoku    = DATEPART(DAYOFYEAR, d)
			FROM d
		) 
			
				SELECT * INTO Dimension.Kalendarz FROM src
				ORDER BY IDData
				OPTION (MAXRECURSION 0);
END;
GO

BEGIN
		ALTER TABLE Dimension.Kalendarz
		ALTER COLUMN IDData date not null
END
GO
BEGIN
		ALTER TABLE Dimension.Kalendarz
		ADD CONSTRAINT PK_Kalendarz PRIMARY KEY (IDData) 
END;
GO


CREATE TABLE Dimension.RodzajPlacowki
	(
	IDRodzajPlacowki tinyint identity(1,1) CONSTRAINT PK_RodzajPlacowki PRIMARY KEY,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	Nazwa varchar(50) not null
	);
GO


CREATE TABLE Dimension.Placowka
	(
	IDPlacowki int identity(1,1) CONSTRAINT PK_Placowka PRIMARY KEY,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	IDRodzajPlacowki tinyint not null,
	NazwaPlacowkiPelna varchar(200) not null,
	Nazwa varchar(50) not null,
	NazwaSkrt varchar(50) not null,
	AdresPelny varchar(255) not null,
	PodmiotNazwa varchar(100) not null,
	Wojewodztwo varchar(50) not null,
	Miasto varchar(200) not null,
	Ulica varchar(100) not null,
	NrDomu varchar(10),
	NrMieszkania varchar(10),
	SzerokoscGeo decimal(10,6),
	DlugoscGeo decimal(10,6),
	CONSTRAINT FK_RodzajPlacowki FOREIGN KEY (IDRodzajPlacowki) REFERENCES Dimension.RodzajPlacowki(IDRodzajPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE
	);
GO


CREATE TABLE Dimension.DaneDokumentu
	(
	IDDokumentu tinyint identity(1,1) CONSTRAINT PK_DaneDokumentu PRIMARY KEY,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	IDAnkietaDB int not null,
	DataUtworzenia date not null,
	GodzinaUtworzenia smalldatetime not null,
	[Czy zebrano ankiety] bit not null,
	WypelniajacyEmail varchar(150) not null,
	WypelniajacyImie varchar(100) not null,
	WypelniajacyNazwisko varchar(200) not null
	CONSTRAINT FK_DaneDokumentu FOREIGN KEY (DataUtworzenia) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE CASCADE
	);
GO


CREATE TABLE Dimension.TrybWypisu
	(
	TrybKod varchar(2) CONSTRAINT PK_TrybWypisu PRIMARY KEY,
	TrybNazwa varchar(100),
	TrybGrupa varchar(30),
	DataImportu SMALLDATETIME NOT NULL DEFAULT GETDATE()
	);
GO


-------------------------------------------------
 /* Tworzenie tabeli schematu Fact oraz relacji*/
-------------------------------------------------

 CREATE TABLE Fact.AnkietaWiek
	(
	IDPlacowki int not null,
	IDDokumentu tinyint not null,
	DataWypelnienia date not null,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	[WiekPacjentow18-29] smallint,
	[WiekPacjentow30-39] smallint,
	[WiekPacjentow40-49] smallint,
	[WiekPacjentow50-69] smallint,
	[WiekPacjentowPowyzej70] smallint,
	CONSTRAINT FK_AnkietaWiekDataWypelnienia FOREIGN KEY (DataWypelnienia) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_AnkietaWiekIDPlacowki FOREIGN KEY (IDPlacowki) REFERENCES Dimension.Placowka(IDPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_AnkietaWiekIDDokumentu FOREIGN KEY (IDDokumentu) REFERENCES Dimension.DaneDokumentu(IDDokumentu)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT PK_AnkietaWiek primary key (IDPlacowki, IDDokumentu, DataWypelnienia)	
	);
GO


 CREATE TABLE Fact.AnkietaPlec
	(
	IDPlacowki int not null,
	IDDokumentu tinyint not null,
	DataWypelnienia date not null,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	[MezczyznaPacjent] smallint,
	[KobietaPacjent] smallint,
	CONSTRAINT FK_AnkietaPlecDataWypelnienia FOREIGN KEY (DataWypelnienia) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_AnkietaPlecIDPlacowki FOREIGN KEY (IDPlacowki) REFERENCES Dimension.Placowka(IDPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_AnkietaPlecIDDokumentu FOREIGN KEY (IDDokumentu) REFERENCES Dimension.DaneDokumentu(IDDokumentu)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT PK_AnkietaPlec primary key (IDPlacowki, IDDokumentu, DataWypelnienia)
	);
GO


CREATE TABLE Fact.AnkietaWyksztalcenie
	(
	IDPlacowki int not null,
	IDDokumentu tinyint not null,
	DataWypelnienia date not null,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	[WyksztalceniePodstawowe] smallint,
	[WyksztalcenieSrednie] smallint,
	[WyksztalcenieWyzsze] smallint,
	[WiekPacjentowPowyzej70] smallint,
	CONSTRAINT FK_AnkietaWyksztalcenieDataWypelnienia FOREIGN KEY (DataWypelnienia) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_AnkietaWyksztalcenieIDPlacowki FOREIGN KEY (IDPlacowki) REFERENCES Dimension.Placowka(IDPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_AnkietaWyksztalcenieIDDokumentu FOREIGN KEY (IDDokumentu) REFERENCES Dimension.DaneDokumentu(IDDokumentu)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT PK_AnkietaWyksztalcenie primary key (IDPlacowki, IDDokumentu, DataWypelnienia)	
	);
GO


 CREATE TABLE Fact.AnkietaPrzyjecieCzasOczekiwania
	(
	IDPlacowki int not null,
	IDDokumentu tinyint not null,
	DataWypelnienia date not null,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	PrzyjecieCzasOczekiwaniaZD smallint,
	PrzyjecieCzasOczekiwaniaRD smallint,
	PrzyjecieCzasOczekiwaniaRZ smallint,
	PrzyjecieCzasOczekiwaniaZZ smallint,
	PrzyjecieCzasOczekiwaniaND smallint,
	CONSTRAINT FK_AnkietaPrzyjecieCzasOczekiwaniaDataWypelnienia FOREIGN KEY (DataWypelnienia) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_AnkietaPrzyjecieCzasOczekiwaniaIDPlacowki FOREIGN KEY (IDPlacowki) REFERENCES Dimension.Placowka(IDPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_AnkietaPrzyjecieCzasOczekiwaniaIDDokumentu FOREIGN KEY (IDDokumentu) REFERENCES Dimension.DaneDokumentu(IDDokumentu)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT PK_AnkietPrzyjecieCzasOczekiwania primary key (IDPlacowki, IDDokumentu, DataWypelnienia)	
	);
GO

 CREATE TABLE Fact.AnkietaPrzyjecieSposobOrganizacji
	(
	IDPlacowki int not null,
	IDDokumentu tinyint not null,
	DataWypelnienia date not null,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	PrzyjecieSposobOrganizacjiZD smallint,
	PrzyjecieSposobOrganizacjiRD smallint,
	PrzyjecieSposobOrganizacjiRZ smallint,
	PrzyjecieSposobOrganizacjiZZ smallint,
	PrzyjecieSposobOrganizacjiND smallint,
	CONSTRAINT FK_AnkietaPrzyjecieSposobOrganizacjiDataWypelnienia FOREIGN KEY (DataWypelnienia) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_AnkietaPrzyjecieSposobOrganizacjiIDPlacowki FOREIGN KEY (IDPlacowki) REFERENCES Dimension.Placowka(IDPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_AnkietPrzyjecieSposobOrganizacjiIDDokumentu FOREIGN KEY (IDDokumentu) REFERENCES Dimension.DaneDokumentu(IDDokumentu)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT PK_AnkietPrzyjecieSposobOrganizacji primary key (IDPlacowki, IDDokumentu, DataWypelnienia)	
	);
GO


 CREATE TABLE Fact.AnkietaPolecenieSzpitala
	(
	IDPlacowki int not null,
	IDDokumentu tinyint not null,
	DataWypelnienia date not null,
	DataImportu SMALLDATETIME not null DEFAULT GETDATE(),
	PolecenieSzpitalaZT smallint,
	PolecenieSzpitalaRT smallint,
	PolecenieSzpitalaRN smallint,
	PolecenieSzpitalaZN smallint,
	CONSTRAINT FK_AnkietaPolecenieSzpitalaDataWypelnienia FOREIGN KEY (DataWypelnienia) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_AnkietaPolecenieSzpitalaIDPlacowki FOREIGN KEY (IDPlacowki) REFERENCES Dimension.Placowka(IDPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_AnkietaPolecenieSzpitalaIDDokumentu FOREIGN KEY (IDDokumentu) REFERENCES Dimension.DaneDokumentu(IDDokumentu)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT PK_AnkietaPolecenieSzpitala primary key (IDPlacowki, IDDokumentu, DataWypelnienia)	
	);
GO


CREATE TABLE Fact.Hospitalizacja
	(
	IDHospitalizacja int identity(1,1) CONSTRAINT PK_Hospitalizacja PRIMARY KEY,
	DataImportu SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	InstancjaPacjentId varchar(15) not null,
	IDPlacowki int not null,
	KSGLDataP date not null,
	KSGLDataW date not null,
	KSGLRodzajKsiegi tinyint not null,
	KSGLRok varchar(4) not null,
	KSGLTrybPrzjeciaKod varchar(2) not null,
	KSGLTrybWypisuKod varchar(2) not null,
	KSODGdzieWypisano varchar(50),
	KSODNumerPacjenta varchar(8) not null,
	KSODTrybWypisuKod varchar(2) not null,
	KSODDataP date not null,
	KSODDataW date not null,
	PacjentPlecKod varchar(1),
	RozpoznanieICD10Kod varchar(10),
	RozpoznanieICD10Nazwa ntext,
	OSOBODNI  int,
	ODDZIAL   varchar(200) not null,
	CONSTRAINT FK_HospitalizacjaKSGLDataP FOREIGN KEY (KSGLDataP) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_HospitalizacjaKSGLDataW FOREIGN KEY (KSGLDataW) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_HospitalizacjaKSODDataP FOREIGN KEY (KSODDataP) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_HospitalizacjaKSODDataW FOREIGN KEY (KSODDataW) REFERENCES Dimension.Kalendarz(IDData)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_HospitalizacjaIDPlacowki FOREIGN KEY (IDPlacowki) REFERENCES Dimension.Placowka(IDPlacowki)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT FK_HospitalizacjaKSGLTrybWypisuKod FOREIGN KEY (KSGLTrybWypisuKod) REFERENCES Dimension.TrybWypisu(TrybKod)
	ON DELETE NO ACTION ON UPDATE CASCADE
	);
GO


--USE testoweDB;
--go

--DROP TABLE

----[Dimension].[TrybWypisu],
----[Fact].[Hospitalizacja],
--[Fact].[AnkietaPolecenieSzpitala],
--[Fact].[AnkietaPrzyjecieCzasOczekiwania],
--[Fact].[AnkietaPrzyjecieSposobOrganizacji],
--[Fact].[AnkietaWiek],
--[Fact].[AnkietaWyksztalcenie],
--[Dimension].[Placowka],
--[Dimension].[RodzajPlacowki],
--[Dimension].[DaneDokumentu],
--[Dimension].[Kalendarz]


--DROP SCHEMA IF EXISTS Integration

--;