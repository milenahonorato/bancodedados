-- **********************************************************************
-- *                                MÉTODO 1                            *
-- **********************************************************************
-- 1) Renomear a tabela CONTEM para ITEM, 
--    remover as chaves estrangeiras, 
--    adicionar a coluna NUM_ITEM_PEDIDO, 
--    modificar a chave primária, 
--    Recriar as chaves extrangeiras.

-- Renomeando a tabela CONTEM para ITEM
ALTER TABLE PIZZARIA.CONTEM RENAME TO PIZZARIA.ITEM;

-- Removendo a chave estrangeira para a tabela PEDIDO
ALTER TABLE PIZZARIA.ITEM DROP FOREIGN KEY FK_CONTEM_2_PEDIDO;

-- Removendo a chave estrangeira para a tabela PIZZA
ALTER TABLE PIZZARIA.ITEM DROP FOREIGN KEY FK_CONTEM_2_PIZZA;
ALTER TABLE PIZZARIA.ITEM DROP INDEX FK_CONTEM_2_PIZZA;

-- adicionando a coluna NUM_ITEM_PEDIDO
ALTER TABLE PIZZARIA.ITEM ADD NUM_ITEM_PEDIDO INT FIRST;

-- Alterando a chave primária para NUM_ITEM_PEDIDO. Precisa no mesmo comando modificá-la para adicionar o AUTO_INCREMent
ALTER TABLE PIZZARIA.ITEM DROP PRIMARY KEY, ADD CONSTRAINT PK_ITEM PRIMARY KEY( NUM_ITEM_PEDIDO ), MODIFY COLUMN NUM_ITEM_PEDIDO INT NOT NULL AUTO_INCREMENT; 

-- Adicionando novamente a chave estrangeira para a tabela PEDIDO
ALTER TABLE PIZZARIA.ITEM ADD CONSTRAINT FK_ITEM_2_PEDIDO
	FOREIGN KEY (NUM_PEDIDO) REFERENCES PIZZARIA.PEDIDO (NUM_PEDIDO);

-- Adicionando novamente a chave estrangeira para a tabela PIZZA
ALTER TABLE PIZZARIA.ITEM ADD CONSTRAINT FK_ITEM_2_PIZZA
	FOREIGN KEY (COD_PIZZA) REFERENCES PIZZARIA.PIZZA (COD_PIZZA);
