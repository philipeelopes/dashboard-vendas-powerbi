CREATE DATABASE varejo_analise;
USE varejo_analise;
SHOW DATABASES;

CREATE TABLE clientes(
	id_cliente INT 	PRIMARY KEY,
    nome_cliente VARCHAR(100),
    estado VARCHAR(2),
    data_cadastro DATE
);

SHOW TABLES;

CREATE TABLE produtos (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(100),
    categoria VARCHAR(50),
    preco_unit DECIMAL(10,2)
);

CREATE TABLE lojas (
    id_loja INT PRIMARY KEY,
    nome_loja VARCHAR(100),
    estado VARCHAR(2)
);


CREATE TABLE vendas (
    id_venda INT PRIMARY KEY,
    data_venda DATE,
    id_cliente INT,
    id_produto INT,
    id_loja INT,
    quantidade INT,
    receita DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
    FOREIGN KEY (id_loja) REFERENCES lojas(id_loja)
);

INSERT INTO clientes VALUES
(5, 'Eduardo Lima', 'SP', '2024-05-10'),
(6, 'Fernanda Alves', 'RJ', '2024-06-02'),
(7, 'Gustavo Pereira', 'MG', '2024-06-18'),
(8, 'Helena Souza', 'SP', '2024-07-01'),
(9, 'Igor Santos', 'BA', '2024-07-15'),
(10,'Juliana Rocha', 'PR', '2024-08-05');


SELECT * FROM clientes;


INSERT INTO produtos VALUES
(5, 'Teclado Mecânico', 'Eletrônicos', 350.00),
(6, 'Headset Gamer', 'Eletrônicos', 500.00),
(7, 'Mesa Escritório', 'Móveis', 1500.00),
(8, 'Webcam', 'Eletrônicos', 300.00);

SELECT * FROM produtos;


INSERT INTO lojas VALUES

(4, 'Loja BA Salvador', 'BA'),
(5, 'Loja PR Curitiba', 'PR');

SELECT * FROM lojas;



INSERT INTO vendas VALUES
(1, '2025-01-05', 1, 1, 1, 1, 3500.00),
(2, '2025-01-10', 2, 2, 1, 2, 160.00),
(3, '2025-02-12', 3, 3, 2, 1, 900.00),
(4, '2025-02-20', 1, 2, 1, 1, 80.00),
(5, '2025-03-15', 2, 1, 2, 1, 3500.00),
(6, '2025-03-18', 4, 4, 3, 1, 1200.00),
(7, '2025-03-22', 1, 3, 1, 1, 900.00);


SELECT * FROM vendas;

SET @id := (SELECT MAX(id_venda) FROM vendas);



INSERT INTO vendas
(id_venda, data_venda, id_cliente, id_produto, id_loja, quantidade, receita)
SELECT
    (@id := @id + 1),
    DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND()*120) DAY),
    c.id_cliente,
    p.id_produto,
    l.id_loja,
    FLOOR(1 + RAND()*3),
    p.preco_unit * FLOOR(1 + RAND()*3)
FROM clientes c
JOIN produtos p
JOIN lojas l
LIMIT 100;

SELECT COUNT(*) FROM vendas;

-- demanda 1 -----------------------------------------------------------------------
-- faturamento total 
SELECT data_venda, receita 
FROM vendas
LIMIT 10;

SELECT SUM(receita) AS 'A receita total é de: ' FROM vendas;

-- faturamento por mes
SELECT 
	data_venda,
    YEAR(data_venda) AS ano,
    MONTH(data_venda) AS mes,
    receita
FROM vendas
LIMIT 10;

SELECT 
	YEAR(data_venda) AS ano,
	MONTH(data_venda) AS mes,
	SUM(receita) AS faturamento_mensal
FROM vendas
GROUP BY 
	YEAR(data_venda),
	MONTH(data_venda)
ORDER BY
	ano,
    mes;
    
-- demanda 2 ----------------------------------------------------
-- 1- Qual loja fatura mais?

SELECT * FROM vendas;

SELECT
	l.nome_loja,
    SUM(v.receita) AS Faturamento_loja
FROM vendas v
JOIN lojas l
	ON v.id_loja = l.id_loja
GROUP BY 
	l.nome_loja
ORDER BY 
	faturamento_loja DESC;

-- demanda 3 ====================================================================

-- 1- Quais produtos vendem mais?
 -- maior quantidade vendida

SELECT 
	p.nome_produto,
	SUM(v.quantidade) AS total_vendido
FROM produtos p
JOIN vendas v
	ON v.id_produto = p.id_produto 
GROUP BY
	p.nome_produto
ORDER BY total_vendido DESC;


--  Produtos mais vendidos por faturamento

SELECT 
	p.nome_produto,
    SUM(receita) AS faturamento
FROM produtos p
JOIN vendas v
	ON  v.id_produto = p.id_produto
GROUP BY 
	p.nome_produto
ORDER BY faturamento DESC;


-- DEMANDA 4 TICKET MEDIO 
-- 1-

SELECT 
	AVG(receita) AS 'Ticket médio' 
FROM vendas;
-- “Em média, quanto cada venda gera de receita?”
 
 
-- 2- Ticket médio por mês
-- “O ticket médio está aumentando ou caindo?”

SELECT 
    YEAR(data_venda) AS ano,
    MONTH(data_venda) AS mes,
    AVG(receita) AS 'Ticket medio'
FROM vendas
GROUP BY 
	YEAR(data_venda),
	MONTH(data_venda)
ORDER BY
 ano,
 mes;


-- Fevereiro teve queda significativa no ticket médio
 -- Recuperação em março
 -- Abril se mantém abaixo do pico, mas melhor que fevereiro
 -- Queda de faturamento em abril não foi causada por ticket médio, e sim por volume de vendas

	

-- 5 demanda  Ranking de Clientes

-- Quais são os clientes mais importantes para a empresa?
-- 1- Faturamento total por cliente

SELECT 
	c.nome_cliente,
    SUM(v.receita) AS faturamento_cliente
FROM vendas v 
JOIN clientes c 
	ON v.id_cliente = c.id_cliente
GROUP BY 
 c.nome_cliente
 ORDER BY faturamento_cliente DESC;
 
-- Cliente 1 e 2 concentram a maior parte do faturamento
-- Forte concentração de receita
-- Possível risco de dependência de poucos clientes
    


SELECT * FROM vendas;

