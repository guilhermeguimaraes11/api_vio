delimiter //

create trigger impedir_alteracao_cpf 
before update on usuario
for each row 
begin 
    if old.cpf <> new.cpf then  
        signal sqlstate '45000'
        set message_text = 'Não é permitido alterar o CPF de um usuario já cadastrado';
        end if;

end; //

delimiter ;

-- Tentativa de atualizar o nome (válido)
update usuario
set name = 'João da Silva'
where id_usuario = 1;

-- Tentativa de atualizar o CPF (deve gerar erro)
update usuario
set cpf = '16000000000'
where id usuario = 1;

