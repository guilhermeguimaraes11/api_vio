-- create database vio_guilherme;

-- use vio_guilherme;

create table usuario (
    id_usuario int auto_increment primary key,
    name varchar(100) not null,
    email varchar(100) not null unique,
    password varchar(255) not null,
    cpf char(11) not null unique,
    data_nascimento date not null
);

insert into usuario (name, email, password, cpf, data_nascimento) values
('João Silva', 'joao.silva@example.com', '$2b$10$5xlNhZpM39WUpyGuBuvl9e3pM4RF/IRJE8vwla5W3UVAlApRrY9dy', '16123456789', '1990-01-15'),


create table organizador (
id_organizador int auto_increment primary key,
nome varchar(100) not null,
email varchar(100) not null unique,
senha varchar(50) not null,
telefone char(11) not null
);

insert into organizador (nome, email, senha, telefone) values
('Organização ABC', 'contato@abc.com', 'senha123', '11111222333'),
('Eventos XYZ', 'info@xyz.com', 'senha123', '11222333444'),
('Festivais BR', 'contato@festbr.com', 'senha123', '11333444555'),
('Eventos GL', 'support@gl.com', 'senha123', '11444555666'),
('Eventos JQ', 'contact@jq.com', 'senha123', '11555666777');

create table evento (
    id_evento int auto_increment primary key,
    nome varchar(100) not null,
    descricao varchar(255) not null,
    data_hora datetime not null,
    local varchar(255) not null,
    fk_id_organizador int not null,
    foreign key (fk_id_organizador) references organizador(id_organizador)
);

insert into evento (nome, data_hora, local, descricao, fk_id_organizador) values
    ('Festival de Verão', '2024-12-15', 'Praia Central', 'Evento de Verão', '1'),
    ('Congresso de Tecnologia', '2024-11-20', 'Centro de Convenções', 'Evento de Tecnologia', '2'),
    ('Show Internacional', '2024-10-30', 'Arena Principal', 'Evento Internacional', '3');

create table ingresso (
    id_ingresso int auto_increment primary key,
    preco decimal(5,2) not null,
    tipo varchar(10) not null,
    fk_id_evento int not null,
    foreign key (fk_id_evento) references evento(id_evento)
);

insert into ingresso (preco, tipo, fk_id_evento) values
    (500, 'VIP', '1'),
    (150, 'PISTA', '1'),
    (200, 'PISTA', '2'),
    (600, 'VIP', '3'),
    (250, 'PISTA', '3');

create table compra(
    id_compra int auto_increment primary key,
    data_compra datetime not null,
    fk_id_usuario int not null,
    foreign key (fk_id_usuario) references usuario(id_usuario)
);

insert into compra (data_compra, fk_id_usuario) values
    ("2024-11-14 19:04", 1),
    ("2024-11-13 17:00", 1),
    ("2024-11-12 15:30", 2),
    ("2024-11-11 14:20", 2);

create table ingresso_compra(
    id_ingresso_compra int auto_increment primary key,
    quantidade int not null,
    fk_id_ingresso int not null,
    foreign key (fk_id_ingresso) references ingresso(id_ingresso),
    fk_id_compra int not null,
    foreign key (fk_id_compra) references compra(id_compra)
);

insert into ingresso_compra(fk_id_compra, fk_id_ingresso, quantidade) values
    (1, 4, 5),
    (1, 5, 2),
    (2, 1, 1),
    (2, 2, 2);
     
create table presenca(
    id_presenca int auto_increment primary key,
    data_hora_checkin datetime,
    fk_id_evento int not null,
    foreign key (fk_id_evento) references evento(id_evento),
    fk_id_compra int not null,
    foreign key (fk_id_compra) references compra(id_compra)
);

create table log_evento (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    mensage VARCHAR(255),
    data_log datetime DEFAULT current_timestamp
);