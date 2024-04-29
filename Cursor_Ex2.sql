Create database Cursor_ex2
go
use Cursor_ex2
go
create table envio (
CPF varchar(20),
NR_LINHA_ARQUIV int,
CD_FILIAL int,
DT_ENVIO datetime,
NR_DDD int,
NR_TELEFONE varchar(10),
NR_RAMAL varchar(10),
DT_PROCESSAMENT datetime,
NM_ENDERECO varchar(200),
NR_ENDERECO int,
NM_COMPLEMENTO varchar(50),
NM_BAIRRO varchar(100),
NR_CEP varchar(10),
NM_CIDADE varchar(100),
NM_UF varchar(2),
)
go
create table endereço(
CPF varchar(20),
CEP varchar(10),
PORTA int,
ENDEREÇO varchar(200),
COMPLEMENTO varchar(100),
BAIRRO varchar(100),
CIDADE varchar(100),
UF Varchar(2))

-- Criacao das procedures
go
create procedure sp_insereenvio
as
declare @cpf as int
declare @cont1 as int
declare @cont2 as int
declare @conttotal as int
set @cpf = 11111
set @cont1 = 1
set @cont2 = 1
set @conttotal = 1
while @cont1 <= @cont2 and @cont2 < = 100
begin
insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
values (cast(@cpf as varchar(20)), @cont1,GETDATE())
insert into endereço (CPF,PORTA,ENDEREÇO)
values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
set @cont1 = @cont1 + 1
set @conttotal = @conttotal + 1
if @cont1 > = @cont2
begin
set @cont1 = 1
set @cont2 = @cont2 + 1
set @cpf = @cpf + 1
end
end

go
exec sp_insereenvio
select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc

go

create procedure sp_move_endereco_para_envio
as

Declare @nome_endereco varchar(200),
		@num_endereco int,
		@consulta_cpf varchar(20),
		@cpf_antigo varchar(20),
		@contador int

		set @contador = 0

DECLARE c CURSOR
	FOR select cpf, endereço, PORTA from endereço order by CPF asc
OPEN c
FETCH NEXT FROM c INTO @consulta_cpf, @nome_endereco, @num_endereco
set @cpf_antigo = @consulta_cpf

WHILE @@FETCH_STATUS = 0 
BEGIN
	if(@cpf_antigo = @consulta_cpf) Begin
		set @contador = @contador + 1
		Update envio set NM_ENDERECO = @nome_endereco, NR_ENDERECO = @num_endereco where CPF = @consulta_cpf and NR_LINHA_ARQUIV = @contador
	end
	else begin
		set @contador = 0
		set @cpf_antigo = @consulta_cpf
		set @contador = @contador + 1

		Update envio set NM_ENDERECO = @nome_endereco, NR_ENDERECO = @num_endereco where CPF = @consulta_cpf and NR_LINHA_ARQUIV = @contador
	end
	FETCH NEXT FROM c INTO @consulta_cpf, @nome_endereco, @num_endereco
END
CLOSE c
DEALLOCATE c

exec sp_move_endereco_para_envio

