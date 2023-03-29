-- https://saopaulopizzas.com.br/quem_somos

USE PIZZARIA;

DROP TABLE IF EXISTS PIZZARIA.INGREDIENTE;
CREATE TABLE IF NOT EXISTS PIZZARIA.INGREDIENTE (
	COD_INGREDIENTE			INT				NOT NULL	AUTO_INCREMENT,
	NOME_INGREDIENTE		VARCHAR(100)	NOT NULL,
	CONSTRAINT PK_INGREDIENTE PRIMARY KEY (COD_INGREDIENTE)
) ENGINE=INNODB;

-- Inserindo os nomes dos Ingredientes na tabela PIZZARIA.INGREDIENTE baseado na tabela PIZZARIA.INGREDIENTES_PIZZA
INSERT INTO PIZZARIA.INGREDIENTE (NOME_INGREDIENTE)
SELECT DISTINCT ING.INGREDIENTE
  FROM PIZZARIA.INGREDIENTES_PIZZA ING
 ORDER BY 1;
 
DROP TABLE IF EXISTS PIZZARIA.PIZZA_USA_INGREDIENTE;
CREATE TABLE IF NOT EXISTS PIZZARIA.PIZZA_USA_INGREDIENTE (
	COD_PIZZA				INT				NOT NULL,
	COD_INGREDIENTE			INT				NOT NULL,
	CONSTRAINT PK_PIZZA_USA_INGREDIENTE PRIMARY KEY (COD_PIZZA, COD_INGREDIENTE),
	CONSTRAINT FK_PIZZA_USA_INGREDIENTE_2_PIZZA
		FOREIGN KEY (COD_PIZZA) REFERENCES PIZZARIA.PIZZA (COD_PIZZA),
	CONSTRAINT FK_PIZZA_USA_INGREDIENTE_2_INGREDIENTE
		FOREIGN KEY (COD_INGREDIENTE) REFERENCES PIZZARIA.INGREDIENTE (COD_INGREDIENTE)
) ENGINE=INNODB;

/*
-- Verifica se todos os ingredientes foram cadastrados
SELECT IPI.COD_PIZZA
      ,IPI.INGREDIENTE
      ,(SELECT ING.COD_INGREDIENTE
          FROM INGREDIENTE ING
         WHERE ING.NOME_INGREDIENTE = IPI.INGREDIENTE) CODIGO
      ,(SELECT ING.NOME_INGREDIENTE
          FROM INGREDIENTE ING
         WHERE ING.NOME_INGREDIENTE = IPI.INGREDIENTE) NOME
  FROM INGREDIENTES_PIZZA IPI
*/

-- Insere os Ingredientes Usados com Base na tabela INGREDIENTES_PIZZA
INSERT INTO PIZZARIA.PIZZA_USA_INGREDIENTE (COD_PIZZA, COD_INGREDIENTE)
SELECT IPI.COD_PIZZA
      ,(SELECT ING.COD_INGREDIENTE
          FROM PIZZARIA.INGREDIENTE ING
         WHERE ING.NOME_INGREDIENTE = IPI.INGREDIENTE) CODIGO
  FROM PIZZARIA.INGREDIENTES_PIZZA IPI;

/*
-- Consulte os Ingredientes de uma Pizza usando a tabela PIZZA_USA_INGREDIENTE  
SELECT PIZ.COD_PIZZA
      ,PIZ.NOME_PIZZA
      ,ING.COD_INGREDIENTE
      ,ING.NOME_INGREDIENTE
  FROM PIZZA PIZ
  JOIN PIZZA_USA_INGREDIENTE PUI ON PIZ.COD_PIZZA = PUI.COD_PIZZA
  JOIN INGREDIENTE           ING ON PUI.COD_INGREDIENTE = ING.COD_INGREDIENTE
 WHERE PIZ.COD_PIZZA = 1;

-- Consulte os Ingredientes de uma Pizza usando a tabela INGREDIENTES_PIZZA 
SELECT PIZ.COD_PIZZA
      ,PIZ.NOME_PIZZA
      ,ING.INGREDIENTE
  FROM PIZZA PIZ
  JOIN INGREDIENTES_PIZZA ING ON PIZ.COD_PIZZA = ING.COD_PIZZA
 WHERE PIZ.COD_PIZZA = 1;
*/

DROP TABLE IF EXISTS PIZZARIA.TABELA_PRECO;
CREATE TABLE IF NOT EXISTS PIZZARIA.TABELA_PRECO (
	COD_PRECO				INT				NOT NULL	AUTO_INCREMENT,
	PRECO_PIZZA_INTEIRA		DECIMAL(10,2)	DEFAULT 0,
	PRECO_PIZZA_BROTO		DECIMAL(10,2)	DEFAULT 0,
	NOME_COR_PRECO			VARCHAR(50)		NOT NULL,
	COD_COR_HTML			VARCHAR(10)		DEFAULT '#C71585',
	CONSTRAINT PK_TABELA_PRECO PRIMARY KEY (COD_PRECO)
) ENGINE=INNODB;

-- Inserindo manualmente os preços das pizzas, de acordo com o cardário de cores da pizzaria SÃO PAULO PIZZAS
INSERT INTO PIZZARIA.TABELA_PRECO (PRECO_PIZZA_INTEIRA, PRECO_PIZZA_BROTO, NOME_COR_PRECO, COD_COR_HTML)
VALUES (43.90, 30.50, 'VERDE', '#3CB371');
INSERT INTO PIZZARIA.TABELA_PRECO (PRECO_PIZZA_INTEIRA, PRECO_PIZZA_BROTO, NOME_COR_PRECO, COD_COR_HTML)
VALUES (50.90, 32.50, 'VERMELHO', '#DC143C');
INSERT INTO PIZZARIA.TABELA_PRECO (PRECO_PIZZA_INTEIRA, PRECO_PIZZA_BROTO, NOME_COR_PRECO, COD_COR_HTML)
VALUES (52.90, 34.50, 'AZUL', '#1E90FF');
INSERT INTO PIZZARIA.TABELA_PRECO (PRECO_PIZZA_INTEIRA, PRECO_PIZZA_BROTO, NOME_COR_PRECO, COD_COR_HTML)
VALUES (58.90, 36.50, 'PRETA', '#000000');
INSERT INTO PIZZARIA.TABELA_PRECO (PRECO_PIZZA_INTEIRA, PRECO_PIZZA_BROTO, NOME_COR_PRECO, COD_COR_HTML)
VALUES (62.90, 37.50, 'AMARELA', '#FFD700');
INSERT INTO PIZZARIA.TABELA_PRECO (PRECO_PIZZA_INTEIRA, PRECO_PIZZA_BROTO, NOME_COR_PRECO, COD_COR_HTML)
VALUES (68.90, 38.50, 'ROXA', '#3CB371');

-- *********************************************************************
-- *                       ALTERANDO A TABELA PIZZA                    *
-- *********************************************************************
-- Adicionando a coluna COD_PRECO
ALTER TABLE PIZZARIA.PIZZA ADD COD_PRECO INT;

-- Atualizando a coluna COD_PRECO com o Código do preço em função do preco na tabela TAMANHO_PIZZA
USE PIZZARIA;
UPDATE PIZZARIA.PIZZA PIZ SET
	   PIZ.COD_PRECO = (SELECT TBP.COD_PRECO
		   		          FROM PIZZARIA.TABELA_PRECO TBP
				         WHERE TBP.PRECO_PIZZA_INTEIRA IN (SELECT PRECO_TAMANHO_PIZZA
				 		   						 	         FROM PIZZARIA.TAMANHO_PIZZA TMP
			 										        WHERE TMP.COD_PIZZA = PIZ.COD_PIZZA
													          AND TMP.DESC_TAMANHO_PIZZA = 'INTEIRA'))
 WHERE PIZ.COD_PIZZA >= 1;
								
-- Modificando a coluna COD_PRECO para NOT NULL
ALTER TABLE PIZZARIA.PIZZA MODIFY COD_PRECO INT NOT NULL;

-- Criando a chave estrangeira com a TABELA_PRECO
ALTER TABLE PIZZARIA.PIZZA ADD 
	CONSTRAINT FK_PIZZA_2_TABELA_PRECO
		FOREIGN KEY (COD_PRECO) REFERENCES PIZZARIA.TABELA_PRECO (COD_PRECO);

-- *********************************************************************
-- *                       ALTERANDO A TABELA CONTEM                   *
-- *********************************************************************
-- Adicionando a coluna tamanho para identificar o tamanho da pizza no pedido
ALTER TABLE PIZZARIA.CONTEM ADD TAMANHO VARCHAR(1) DEFAULT 'I' COMMENT "I-INTEIRA; B-BROTO" AFTER COD_PIZZA;

-- Adicionando uma CONSTRAINT CHECK para permitir apenas I (Inteira) ou B (Broto)
ALTER TABLE PIZZARIA.CONTEM ADD 
	CONSTRAINT CK_CONTEM_TAMANHO CHECK (TAMANHO IN ('I','B'));

-- Inserindo o valor para a coluna com base na primeira letra da coluna DSC_TAMANHO_PIZZA
UPDATE PIZZARIA.CONTEM SET 
	TAMANHO = SUBSTRING(DESC_TAMANHO_PIZZA, 1, 1)
 WHERE NUM_PEDIDO >= 1;

-- Removendo a CONSTRAINT e ÍNDICE FK_CONTEM_2_TAMANHO_PIZZA
ALTER TABLE PIZZARIA.CONTEM DROP FOREIGN KEY FK_CONTEM_2_TAMANHO_PIZZA;
ALTER TABLE PIZZARIA.CONTEM DROP INDEX FK_CONTEM_2_TAMANHO_PIZZA;

-- Removendo a PRIMARY KEY
ALTER TABLE PIZZARIA.CONTEM DROP PRIMARY KEY, ADD CONSTRAINT PK_CONTEM PRIMARY KEY( NUM_PEDIDO, COD_PIZZA, TAMANHO);

-- Removendo a coluna DESC_TAMANHO_PIZZA
ALTER TABLE PIZZARIA.CONTEM DROP COLUMN DESC_TAMANHO_PIZZA;

-- Adicionando a Chave Estrangeira para a tabela PIZZARIA.PIZZA
ALTER TABLE PIZZARIA.CONTEM ADD
	CONSTRAINT FK_CONTEM_2_PIZZA
		FOREIGN KEY (COD_PIZZA) REFERENCES PIZZARIA.PIZZA (COD_PIZZA);

-- Removendo a tabela PIZZARIA.INGREDIENTES_PIZZA
DROP TABLE PIZZARIA.INGREDIENTES_PIZZA;
