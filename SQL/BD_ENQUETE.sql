CREATE DATABASE IF NOT EXISTS BD_ENQUETE;
USE BD_ENQUETE;

CREATE TABLE IF NOT EXISTS USUARIOS (
	USU_CODIGO INT AUTO_INCREMENT,
    USU_DATA_CADASTRO DATE NOT NULL,
    USU_LOGIN VARCHAR (50) NOT NULL UNIQUE, -- LOGIN É UNÍCO 
    USU_AREA_ATUACAO VARCHAR (50) ,
    USU_PROFISSAO VARCHAR (50),
    USU_AREA_FORMACAO VARCHAR (50),
    USU_DATA_NASCIMENTO DATE,
    USU_ESTADO_CIVIL ENUM ("Solteiro", "Casado", "Divorciado", "Viúvo") NOT NULL,
    USU_ESTADO VARCHAR (2) NOT NULL,
    USU_ESCOLARIDADE ENUM ("Fundamental completo", "Médio completo", "Superior")  NOT NULL,
    USU_EMAIL VARCHAR (100) NOT NULL UNIQUE,
    USU_SENHA VARCHAR (255) NOT NULL,
    USU_NOME VARCHAR (100) NOT NULL,
    PRIMARY KEY (USU_CODIGO)
);

CREATE TABLE IF NOT EXISTS ENQUETE (
	ENQ_CODIGO INT AUTO_INCREMENT,
    ENQ_DATA_INICIAL DATE NOT NULL,
    ENQ_DATA_FINAL DATE,
    ENQ_DESCRICAO VARCHAR (255),
    ENQ_NOME VARCHAR (100) NOT NULL UNIQUE,
    PRIMARY KEY (ENQ_CODIGO)
);

CREATE TABLE IF NOT EXISTS PERGUNTAS (
	PER_CODIGO INT AUTO_INCREMENT,
    PER_DESCRICAO VARCHAR (500) NOT NULL,
    FK_ENQ_CODIGO INT NOT NULL,
    PRIMARY KEY (PER_CODIGO),
    FOREIGN KEY (FK_ENQ_CODIGO) REFERENCES ENQUETE(ENQ_CODIGO) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS RESPOSTAS (
	RES_CODIGO INT AUTO_INCREMENT,
    RES_DESCRICAO VARCHAR (500) NOT NULL,
    RES_CERTA VARCHAR (10) NOT NULL,
    FK_PER_CODIGO INT NOT NULL,
    PRIMARY KEY (RES_CODIGO),
    FOREIGN KEY (FK_PER_CODIGO) REFERENCES PERGUNTAS(PER_CODIGO) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS USUARIO_RESPONDE_ENQUETE (
	URE_CODIGO INT AUTO_INCREMENT,
    URE_DATA DATE NOT NULL,
    FK_USU_CODIGO INT NOT NULL,
    FK_ENQ_CODIGO INT NOT NULL,
    PRIMARY KEY (URE_CODIGO),
    FOREIGN KEY (FK_USU_CODIGO) REFERENCES USUARIOS (USU_CODIGO) ON DELETE CASCADE,
    FOREIGN KEY (FK_ENQ_CODIGO) REFERENCES ENQUETE(ENQ_CODIGO) ON DELETE CASCADE
);

-- INDICES DE CONSULTA (SELECT)
-- Criar índices em campos com alta chance de serem buscadas em um select
-- Unique e Primary key já tem indice automaricamente

CREATE INDEX IDX_USUARIO_AREA_ATUACAO ON USUARIOS (USU_AREA_ATUACAO);
CREATE INDEX IDX_USUARIO_AREA_FORMACAO ON USUARIOS (USU_AREA_FORMACAO);
CREATE INDEX IDX_USUARIO_ESCOLARIDADE ON USUARIOS (USU_ESCOLARIDADE);
CREATE INDEX IDX_URE_USUARIO_ENQUETE ON USUARIO_RESPONDE_ENQUETE (FK_USU_CODIGO, FK_ENQ_CODIGO);

-- DCL - DATA CONTROL LANGUAGE
-- 1 CRIAR USUÁRIOS

CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'admin@123';
CREATE USER 'Tobias'@'localhost' IDENTIFIED BY 'Tobias@1234';

-- 2 verificar se os usuários foram criados
SELECT USER, HOST
FROM MYSQL.USER;

-- 3 conceder permissões para os usuários
-- DAR TODOS OS PRIVILÉGIOS EM TODAS AS TABELAS PARA O ADMIN
GRANT ALL PRIVILEGES ON BD_ENQUETE .* TO 'Admin'@'localhost';

-- LIBERAR APENAS INSERT E SELECT PARA O SEU USUÁRIO
GRANT INSERT ON BD_ENQUETE .* TO 'Tobias'@'localhost';
GRANT SELECT ON BD_ENQUETE .* TO 'Tobias'@'localhost';
GRANT UPDATE ON BD_ENQUETE.RESPOSTAS TO 'Tobias'@'localhost';

-- 4 Revogar uma permissão
REVOKE UPDATE ON BD_ENQUETE.RESPOSTAS FROM 'Tobias'@'localhost';

-- Fazer 5 insert em cada tabela

INSERT INTO USUARIOS (
					USU_DATA_CADASTRO,
                    USU_LOGIN,
					USU_AREA_ATUACAO, 
					USU_PROFISSAO, 
					USU_AREA_FORMACAO,
                    USU_DATA_NASCIMENTO,
                    USU_ESTADO_CIVIL,
                    USU_ESTADO,
                    USU_ESCOLARIDADE,
                    USU_EMAIL,
                    USU_SENHA,
                    USU_NOME
                    )
VALUES (NOW(), 'Tobias.barbosa', 'Estudante', 'Auto Peças', 'Não formado', '2009-10-01', 'Casado', 'SP', 'Fundamental completo', 'tobias@gmail.com', '1234', 'Tobias Barbosa Moreira'),
		(NOW(), 'lucas.pietro', 'Estudante', 'Reciclagem', 'Não formado', '2009-07-11', 'Solteiro', 'SP', 'Fundamental completo', 'lucas@gmail.com', '12345', 'Lucas Pietro'),
        (NOW(), 'enzo.rosa', 'Estudante', 'Nenhuma', 'Não formada', '2009-11-20', 'Solteiro', 'SP', 'Fundamental completo', 'enzo@gmail.com', '12344', 'Enzo Rosinha'),
        (NOW(), 'caua.moreira', 'Estudante', 'Chapeiro', 'Não formada', '2009-06-26', 'Casado', 'SP', 'Fundamental completo', 'caua@gmail.com', '12234', 'Cauã Moreira'),
        (NOW(), 'pedro.biondo', 'Estudante', 'Fazenda', 'Não formada', '2009-11-21', 'Casado', 'SP', 'Fundamental completo', 'pedro@gmail.com', '123214', 'Pedro Biondo');
        
SELECT * FROM USUARIOS;

INSERT INTO ENQUETE (
					ENQ_DATA_INICIAL,
                    ENQ_DATA_FINAL,
                    ENQ_DESCRICAO,
                    ENQ_NOME
)

VALUES (NOW(), '2027-01-01', 'Enquete sobre futebol', 'Melhor jogador da história'),
		(NOW(), '2027-01-01', 'Enquete sobre tênis', 'Tênis mais bonito'),
        (NOW(), '2027-01-01', 'Enquete sobre carros', 'Carro dos sonhos'),
        (NOW(), '2027-01-01', 'Enquete sobre escola', 'Melhor dia para se faltar'),
        (NOW(), '2027-01-01', 'Enquete sobre tudo', 'Qualquer tema');

SELECT * FROM ENQUETE; 

INSERT INTO PERGUNTAS (
						PER_DESCRICAO,
                        FK_ENQ_CODIGO
)

VALUES ( 'Cristiano Ronaldo ou Messi', 1),
		(' Nike ou Adidas?', 2),
        ('Jetta ou civic?', 3),
        ('Segunda ou sexta?', 4),
        ('Enzo ou cauã (qual o pior?)', 5);
        
SELECT * FROM PERGUNTAS;

INSERT INTO RESPOSTAS (
						RES_DESCRICAO,
                        RES_CERTA,
                        FK_PER_CODIGO
)

VALUES ('Cristiano ronaldo é melhor', 'Certo',6),
	   ('Nike é melhor', 'Certo', 7),
        ('Jetta é melhor', 'Errado', 8),
        ('Sexta é melhor', 'Certo', 9),
         ('Enzo é pior', 'Errado', 10);
         
SELECT * FROM RESPOSTAS ;

INSERT INTO USUARIO_RESPONDE_ENQUETE (
									URE_DATA,
                                    FK_USU_CODIGO,
                                    FK_ENQ_CODIGO
)

VALUES (NOW(), 1 , 1),
		(NOW(), 2 , 1),
        (NOW(), 3 , 1),
        (NOW(), 4 , 1),
        (NOW(), 5 , 1);
        
SELECT * FROM USUARIO_RESPONDE_ENQUETE;

ALTER TABLE PERGUNTAS (PER_CODIGO)