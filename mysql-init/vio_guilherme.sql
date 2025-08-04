-- create database vio_guilherme;

-- use vio_guilherme;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL
);

INSERT INTO usuario (name, email, password, cpf, data_nascimento) VALUES
('João Silva', 'joao.silva@example.com', '$2b$10$.dhNDXvJnzi2Cw4c7tUvsO4FxdpkA.PzzyQpdu6exZ8mdJWwB4nSW', '16123456789', '1990-01-15');

CREATE TABLE organizador (
id_organizador INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
senha VARCHAR(255) NOT NULL,
telefone CHAR(11) NOT NULL
);

INSERT INTO organizador (nome, email, senha, telefone) VALUES
('Organização ABC', 'contato@abc.com', 'senha123', '11111222333'),
('Eventos XYZ', 'info@xyz.com', 'senha123', '11222333444'),
('Festivais BR', 'contato@festbr.com', 'senha123', '11333444555'),
('Eventos GL', 'support@gl.com', 'senha123', '11444555666'),
('Eventos JQ', 'contact@jq.com', 'senha123', '11555666777');

CREATE TABLE evento (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    data_hora DATETIME NOT NULL,
    local VARCHAR(255) NOT NULL,
    fk_id_organizador INT NOT NULL,
    FOREIGN KEY (fk_id_organizador) REFERENCES organizador(id_organizador)
);

INSERT INTO evento (nome, data_hora, local, descricao, fk_id_organizador) VALUES
    ('Festival de Verão', '2024-12-31 07:00:00', 'Praia Central', 'Evento de Verão', 1),
    ('Congresso de Tecnologia', '2024-12-31 07:00:00', 'Centro de Convenções', 'Evento de Tecnologia', 2),
    ('Show Internacional', '2024-12-31 07:00:00', 'Arena Principal', 'Evento Internacional', 3),
    ('Feira Cultural de Inverno', '2025-07-20 18:00:00', 'Parque Municipal', 'Evento cultural com música e gastronomia', 1);

CREATE TABLE ingresso (
    id_ingresso INT AUTO_INCREMENT PRIMARY KEY,
    preco DECIMAL(5,2) NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    fk_id_evento INT NOT NULL,
    FOREIGN KEY (fk_id_evento) REFERENCES evento(id_evento)
);

INSERT INTO ingresso (preco, tipo, fk_id_evento) VALUES
    (500, 'VIP', 1),
    (150, 'PISTA', 1),
    (200, 'PISTA', 2),
    (600, 'VIP', 3),
    (250, 'PISTA', 3);

CREATE TABLE compra(
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    data_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    fk_id_usuario INT NOT NULL,
    FOREIGN KEY (fk_id_usuario) REFERENCES usuario(id_usuario)
);

INSERT INTO compra (data_compra, fk_id_usuario) VALUES
    ('2025-12-31 23:00:00', 1),
    ('2025-12-31 23:00:00', 1),
    ('2025-01-01 23:00:00', 1),
    ('2025-01-01 23:00:00', 1);

CREATE TABLE ingresso_compra(
    id_ingresso_compra INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT NOT NULL,
    fk_id_ingresso INT NOT NULL,
    FOREIGN KEY (fk_id_ingresso) REFERENCES ingresso(id_ingresso),
    fk_id_compra INT NOT NULL,
    FOREIGN KEY (fk_id_compra) REFERENCES compra(id_compra)
);

INSERT INTO ingresso_compra(fk_id_compra, fk_id_ingresso, quantidade) VALUES
    (1, 4, 5),
    (1, 5, 2),
    (2, 1, 1),
    (2, 2, 2);

CREATE TABLE presenca(
    id_presenca INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_checkin DATETIME,
    fk_id_evento INT NOT NULL,
    FOREIGN KEY (fk_id_evento) REFERENCES evento(id_evento),
    fk_id_compra INT NOT NULL,
    FOREIGN KEY (fk_id_compra) REFERENCES compra(id_compra)
);

CREATE TABLE log_evento (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    mensage VARCHAR(255),
    data_log DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE historico_compra(
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    data_compra DATETIME NOT NULL,
    id_usuario INT NOT NULL,
    data_exclusao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE resumo_evento (
    id_evento INT PRIMARY KEY,
    total_ingressos INT
);


ALTER TABLE evento ADD imagem LONGBLOB;