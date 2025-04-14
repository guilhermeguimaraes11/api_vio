-- Criação de function
delimiter $$
create function calcula_idade(datanascimento date)
returns int
deterministic
contains sql
begin
    declare idade int;
    set idade = timestampdiff(year, datanascimento, curdate());
    return idade;
end; $$
delimiter ;

-- Verifica se a função especificada foi criada
SHOW CREATE FUNCTION calcula_idade;

SELECT name, calcula_idade(data_nascimento) AS idade FROM usuario;


delimiter $$
create function status_sistema()
returns varchar(50)
no sql
begin
    return 'Sistema operando normalmente';
end; $$
delimiter ;


-- Execução da query
select status_sistema();


delimiter $$
create function total_compras_usuario(id_usuario int)
returns int
reads sql data
begin
    declare total int;
    select count(*) into total
    from compra
    where id_usuario = compra.fk_id_usuario;

    return total;
end; $$
delimiter ;

select total_compras_usuario(3) as "Total de compras";

delimiter $$
create function mensagem_boas_vindas(nome_usuario varchar(100))
returns varchar(255)
deterministic
contains sql 
begin
    declare msg varchar(255);
    set msg = concat('Ola, ',nome_usuario, '! Seja bem-vindo(a) ao sistema VIO.');
    return msg;
end; $$
delimiter ;

select mensagem_boas_vindas("Marcos");

select routine_name from
information_schema.routines
    where routine_type = 'FUNCTION'
        and routine_schema = 'vio_guilherme';

-- Maior de idade
delimiter $$

create function is_maior_idade(data_nascimento date)
returns boolean 
not deterministic
contains sql
begin 
    declare idade int;

-- utilizando a função já criada
    set idade = calcula_idade(data_nascimento);
    return idade >= 18;
end; $$

delimiter ;

select is_maior_idade("2007-08-08") as "é maior de idade?";
  
-- categorizar usuários por faixa etária
delimiter $$ 

create function faixa_etaria(data_nascimento date)
returns varchar(20)
not deterministic
contains sql
begin 
    declare idade int;

-- cálculo da idade com a funçao já criada 
    set idade = calcula_idade(data_nascimento);
    
    if idade < 18 then
        return "Menor de idade";

    elseif idade < 60 then 
        return "Adulto";
    
    else
        return "Idoso";

    end if;
end; $$

delimiter ;

-- agrupar clientes por faixa etária
select faixa_etaria(data_nascimento) as faixa, count(*) as quantidade from usuario
group by faixa;

-- identificar uma faixa etária específica
select name from usuario
    where faixa_etaria(data_nascimento) = "Adulto";

-- calcular a média de idade de usuário 
delimiter $$
create function media_idade()
returns decimal(5, 2)
not deterministic
reads sql data
begin 
    declare media decimal(5, 2);

-- cálculo da média das idades
select avg(timestampdiff(year, data_nascimento, curdate())) into media from usuario;

return ifnull(media, 0);
end; $$
delimiter;


-- selecionar idade específica
select "A média de idade dos clientes é maior que 30" as resultado where media_idade() > 30

-- Exercicio direcionado
-- calculo do total gastado por usuario 
delimiter $$

create function calcula_total_gasto(pid_usuario int)
returns decimal(10,2)
not deterministic
reads sql data
begin
    declare total decimal(10,2);

    select sum(i.preco * ic.quantidade) into total
    from compra c
    join ingresso_compra ic on c.id_compra = ic.fk_id_compra
    join ingresso i on i.id_ingresso = ic.fk_id_ingresso
    where c.fk_id_usuario = pid_usuario;

    return ifnull(total, 0);
end$$

DELIMITER ;

-- buscar a faixa etaria de um usuario
delimiter $$
create function buscar_faixa_etaria_usuario(pid int)
returns varchar(20)
not deterministic
reads sql data
begin  
    declare nascimento date;
    declare faixa varchar(20);

select data_nascimento into nascimento
from usuario 
where id_usuario = pid;

set faixa = faixa_etaria(nascimento);

return faixa;
end; $$
delimiter;

-- exercicio 
delimiter $$

create function total_ingressos_vendidos(id_evento int)
returns int
deterministic
begin
    declare total int;

    select ifnull(sum(ic.quantidade), 0)
    into total
    from ingresso_compra ic
    join ingresso i on ic.fk_id_ingresso = i.id_ingresso
    where i.fk_id_evento = id_evento;

    return total;
end; $$

delimiter;


delimiter $$

create function renda_total_evento(id_evento int)
returns decimal(10,2)
deterministic
begin
    declare renda decimal(10,2);

    select ifnull(sum(i.preco * ic.quantidade), 0.00)
    into renda
    from ingresso_compra ic
    join ingresso i on ic.fk_id_ingresso = i.id_ingresso
    where i.fk_id_evento = id_evento;

    return renda;
end;
$$

delimiter;