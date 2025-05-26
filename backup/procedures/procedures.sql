delimiter //

CREATE PROCEDURE `registrar_compra`(
    in p_id_usuario int,
    in p_id_ingresso int,
    in p_quantidade int
)
begin
    declare v_id_compra int;
    declare v_data_evento datetime;
    
    -- obtem a data do evento
    select e.data_hora into v_data_evento
    from ingresso i 
    join evento e on i.fk_id_evento = e.id_evento
    where i.id_ingresso  =  p_id_ingresso;
    
    -- verificar se a data do evento é menor que a atual
    if date(v_data_evento) < curdate() then
        signal sqlstate '45000'
        set message_text = 'ERRO_PROCEDURE - Não é possivel comprar ingressos para eventos passados';
    end if;
    
    -- Criar registro na tabela 'compra'
    insert into compra (data_compra, fk_id_usuario)
    values (now(), p_id_usuario);

    -- Obter o ID da compra recém-criada
    set v_id_compra = last_insert_id();

    -- Registrar os ingressos comprados
    insert into ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
        values(v_id_compra, p_id_ingresso, p_quantidade);

end; //

delimiter ; 



delimiter //

create procedure total_ingressos_usuario(
    in p_id_usuario int,
    out p_total_ingressos int
)
begin
    -- Inicializar o valor de saída
    set p_total_ingressos = 0;

    -- Consultar e somar todos os ingressos comprados pelo usuário
    select coalesce(sum(ic.quantidade), 0)
    into p_total_ingressos
    from ingresso_compra ic
    join compra c on ic.fk_id_compra = c.id_compra
    where c.fk_id_usuario = p_id_usuario;
end;
//

delimiter ;



show procedure status where db = 'vio_guilherme';
set @total = 0;
call total_ingressos_usuario (2, @total);



delimiter //

create procedure registrar_presenca(
    in p_id_compra int,
    out p_id_evento int
)
begin
    -- Registrar presença
    insert into presenca (data_hora_checkin, fk_id_evento, fk_id_compra)
    values (now(), p_id_evento, p_id_compra);
end; //

delimiter ;



-- Tabela para testar a clausula
create table log_evento (
    id_log int AUTO_INCREMENT PRIMARY KEY,
    mensagem varchar(255),
    data_log datetime default current_timestamp
);

delimiter $$
create function registrar_log_evento(texto  varchar(255))
returns varchar(50)
not deterministic
modifies sql data
begin
    insert into log_evento(mensagem)
    values (texto);

    return 'Log inserido com sucesso';
end; $$

delimiter ;

-- Visualiza o estado da variavel de controle para permissões de criação de funções
show variables like 'log_bin_trust_function_creators';

-- Atualiza o estado da variavel de controle
set global log_bin_trust_function_creators = 1;

select registrar_log_evento('teste') as log;

-- procedure para resumo do usuario
delimiter $$

create procedure resumo_usuario(in pid int)
begin
    declare nome varchar(100);
    declare email varchar(100);
    declare totalrs decimal(10, 2);  
    declare faixa varchar(20);

    -- busca o nome e o email do usuario
    select u.name, u.email into nome, email
    from usuario u
    where u.id_usuario = pid;

    -- chamada das funções específicas já criadas
    set totalrs = calcula_total_gasto(pid);
    set faixa = buscar_faixa_etaria_usuario(pid);

    -- exibe os dados formatados
    select nome as nome_usuario,
           email as email_usuario,
           totalrs as total_gasto,
           faixa as faixa_etaria;
end$$

delimiter ;
