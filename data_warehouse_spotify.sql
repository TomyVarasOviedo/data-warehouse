-- ==========================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS: Data Warehouse Spotify
-- Compatible con SQL Server / MySQL / PostgreSQL
-- Autor: Tomas Varas
-- ==========================================================


-- ============================
-- DIMENSIONES
-- ============================

CREATE TABLE Dim_fecha (
    id_date BIGINT PRIMARY KEY NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    hora_minuto_segundo TIME
);

CREATE TABLE Dim_plataforma (
    id_plataforma INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Dim_razon (
    id_razon INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Dim_artista (
    id_artista INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(200) NOT NULL
);

CREATE TABLE Dim_album (
    id_album INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(200) NOT NULL,
    artista_id INT NOT NULL,
    fecha_publicacion DATETIME,
    FOREIGN KEY (artista_id) REFERENCES Dim_artista(id_artista)
);

CREATE TABLE Dim_cancion (
    id_track INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(200) NOT NULL,
    artista_id INT NOT NULL,
    album_id INT NOT NULL,
    duracion_ms BIGINT,
    FOREIGN KEY (artista_id) REFERENCES Dim_artista(id_artista),
    FOREIGN KEY (album_id) REFERENCES Dim_album(id_album)
);

CREATE TABLE Dim_concierto (
    id_concierto INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(200) NOT NULL,
    pais VARCHAR(200),
    capacidad_lugar INT
);

-- ============================
-- TABLAS DE HECHOS
-- ============================

CREATE TABLE Facts_spotify (
    playback_id BIGINT PRIMARY KEY IDENTITY(1,1),
    fecha_id BIGINT NOT NULL,
    cancion_id INT NOT NULL,
    artista_id INT NOT NULL,
    album_id INT NOT NULL,
    plataforma_id INT NOT NULL,
    aleatorio_llegada BIT,
    razon_llegada INT,
    razon_salida INT,
    omitida BIT,
    tiempo_escucha INT,
    FOREIGN KEY (fecha_id) REFERENCES Dim_fecha(id_date),
    FOREIGN KEY (cancion_id) REFERENCES Dim_cancion(id_track),
    FOREIGN KEY (artista_id) REFERENCES Dim_artista(id_artista),
    FOREIGN KEY (album_id) REFERENCES Dim_album(id_album),
    FOREIGN KEY (plataforma_id) REFERENCES Dim_plataforma(id_plataforma),
    FOREIGN KEY (razon_llegada) REFERENCES Dim_razon(id_razon),
    FOREIGN KEY (razon_salida) REFERENCES Dim_razon(id_razon)
);

CREATE TABLE Facts_concierto (
    id_fact_concierto BIGINT PRIMARY KEY IDENTITY(1,1),
    fecha_id BIGINT NOT NULL,
    cancion_id INT NOT NULL,
    concierto_id INT NOT NULL,
    artista_id INT NOT NULL,
    cantidad_publico INT,
    cantidad_entradas_vendidas INT,
    FOREIGN KEY (fecha_id) REFERENCES Dim_fecha(id_date),
    FOREIGN KEY (cancion_id) REFERENCES Dim_cancion(id_track),
    FOREIGN KEY (concierto_id) REFERENCES Dim_concierto(id_concierto),
    FOREIGN KEY (artista_id) REFERENCES Dim_artista(id_artista)
);

-- ==========================================================
-- FIN DEL SCRIPT
-- ==========================================================
