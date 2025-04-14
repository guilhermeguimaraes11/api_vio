-- ip da maquina: 10.89.240.78
-- total de ingresso
delimiter $$

create function total_ingressos_vendidos(id_evento int)
returns int
not deterministic
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

-- renda total
delimiter $$

create function renda_total_evento(id_evento int)
returns decimal(10,2)
not deterministic
begin
    declare renda decimal(10,2);

    select ifnull(sum(i.preco * ic.quantidade), 0)
    into renda
    from ingresso_compra ic
    join ingresso i on ic.fk_id_ingresso = i.id_ingresso
    where i.fk_id_evento = id_evento;

    return renda;
end;
$$

delimiter;

-- procedure evento
delimiter $$

create procedure resumo_evento (in id_evento int)
begin
    declare nome_evento varchar(100);
    declare data_evento date;
    declare total_vendidos int;
    declare renda_total decimal(10,2);

    -- Buscar nome e data
    select e.nome, e.data_hora
    into nome_evento, data_evento
    from evento e
    where e.id_evento = id_evento;

    -- Obter dados via funções
    set total_vendidos = total_ingressos_vendidos(id_evento);
    set renda_total = renda_total_evento(id_evento);

    -- Exibir o resumo
    select
        nome_evento as Nome,
        data_evento as Data_Hora,
        total_vendidos as Total_Ingressos_Vendidos,
        renda_total as Renda_Total;
end; $$

delimiter ;

