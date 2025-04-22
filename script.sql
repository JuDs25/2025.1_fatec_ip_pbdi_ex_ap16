-- JULIA
--  1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver
--  video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.
DO $$
DECLARE
	--1. Declaração do cursor e da variável tupla que irá armazenar o que o cursor aponta
	-- cursor vinculado
	cur_rank_youtuber CURSOR FOR 
	SELECT rank, youtuber FROM tb_top_youtubers
	-- "Pelo menos" é uma ideia de "maior ou igual" (≥)
	WHERE ((video_count >= 1000) AND (category = 'Sports' or category = 'Music'));
	tupla RECORD;
	v_list_rank_youtuber TEXT := ''; -- variável para concatenar
BEGIN
	--2. Abertura do meu cursor
	OPEN cur_rank_youtuber;
	-- 3. Meu cursor pega os dados e inclui na variavel tupla
	FETCH cur_rank_youtuber INTO tupla;
	-- enquanto ele encontrar dados segue o LOOP
	WHILE FOUND
		LOOP
		-- concatenando as variáveis que preciso apresentar
			v_list_rank_youtuber := v_list_rank_youtuber || tupla.rank || ':'|| tupla.youtuber || ' | ';
			FETCH cur_rank_youtuber INTO tupla; -- iteração
		END LOOP;
	CLOSE cur_rank_youtuber;
	-- 4. Apresentando as variáveis solicitadas -> rank e youtuber
	RAISE NOTICE '%', v_list_rank_youtuber;
END;
$$

--  1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa. Para tal--
-- O SELECT deverá ordenar em ordem não reversa
-- O Cursor deverá ser movido para a última tupla
-- Os dados deverão ser exibidos de baixo para cima
DO $$
DECLARE
	--1. Declarando as minha variáveis
	-- Criando o cursor não vinculado, porque não existe um parâmetro inicial e sim geral
	cur_nome_youtuber REFCURSOR;
	tupla RECORD;
BEGIN
	-- 2. Abrindo meu cursor em modo Scroll para poder ir para cima e para baixo
	OPEN cur_nome_youtuber SCROLL FOR
	SELECT youtuber FROM tb_top_youtubers;
-- 3. Para criar a repetição e garantir a seleção de todos os youtubers
	-- vai para o fim, para depois poder ir de baixo para cima
	LOOP
		FETCH cur_nome_youtuber INTO tupla;
		EXIT WHEN NOT FOUND;
	END LOOP;
	-- agora sim ele vai de baixo para cima e apresenta os dados
	LOOP
		FETCH BACKWARD FROM cur_nome_youtuber INTO tupla;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', tupla.youtuber;
	END LOOP;
	-- 4. Fecha o cursor
    CLOSE cur_nome_youtuber;
END;
$$
-- SELECT * FROM tb_top_youtubers;

-- HELENA 

-- 1.3 anti-pattern 'ROW BY AGONIZING ROW':
-- O anti-pattern "ROW BY AGONIZING ROW" faz referência ao uso inadequado de abordagens baseadas em linha (como cursores, loops e atualizações linha por linha) em um banco de dados relacional, que foi projetado para ser set-based (ou seja, projetado para trabalhar com conjuntos de dados).
--No caso de "Row by Agonizing Row", o uso de cursores e loops para processar dados linha por linha é considerado um anti-pattern, pois isso vai contra os princípios do SQL e das operações em conjuntos de dados.
-- Este nome 'ROW BY AGONIZING ROW' soa como um deboche, agonizing~, como se estivessemos subvertendo a maneira correta de usar SQL ao pegarmos linha por linha (como fazemos quando usamos cursores e loops), o SQL foi projetado para trabalhar com conjuntos de dados de uma só vez, otimizando o tempo de execução e utilizando recursos computacionais de maneira mais eficiente. 
--Nos artigos que li eles destacam que cursores e loops só devem ser usados se forem REALMENTE NECESSÁRIOS, do contrário devemos utilizar índices e particionamento, funções agregadas, CTEs etc, basicamente ROW BY AGONIZING ROW reflete sobre desempenho ineficiente e uso excessivo de recursos.

-- 1.2 cursor que exibe todos os nomes dos youtubers em ordem reversa:
--SELECT deverá ordenar em ordem não reversa
--o cursor deverá ser movido para a última tupla
--os dados deverão ser exibidos de baixo para cima
DO $$
DECLARE
    v_youtuber VARCHAR(200);
-- 1. declaração
    cur_youtubers_desc CURSOR FOR 
    SELECT youtuber
    FROM tb_top_youtubers
	ORDER BY youtuber
    ;
BEGIN
-- 2. abertura
    OPEN cur_youtubers_desc;
-- mover o cursor para o final
    MOVE LAST FROM cur_youtubers_desc;
    LOOP
-- 3. recuperação de dados
        FETCH PRIOR FROM cur_youtubers_desc INTO v_youtuber;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%', v_youtuber;
    END LOOP;
-- 4. fechamento
    CLOSE cur_youtubers_desc;
END;
$$

-- se fosse com ordenação direto no SELECT
DO $$
DECLARE
    v_youtuber VARCHAR(200);
-- cursor com SELECT ordenado de forma decrescente
    cur_youtubers_desc CURSOR FOR
        SELECT youtuber
        FROM tb_top_youtubers
        ORDER BY youtuber DESC;
BEGIN
-- 2. abertura
    OPEN cur_youtubers_desc;
    -- percorre normalmente (de cima pra baixo, pois o DESC esta no SELECT)
    LOOP
-- 3. recuperação de dados
        FETCH cur_youtubers_desc INTO v_youtuber;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%', v_youtuber;
    END LOOP;
-- 4. fechamento
    CLOSE cur_youtubers_desc;
END;
$$;


-- 1.1 cursor que exiba as variáveis rank e youtuber de toda tupla que tiver video_count pelo menos igual a 1000 e cuja category seja igual a 'Sports' ou 'Music'
DO $$
DECLARE
-- 1. declaração do cursor
-- não vinculado
    cur_sports_music REFCURSOR;
    v_youtuber VARCHAR(200);
    v_rank INT;
    v_video_count INT := 1000;
    v_category1 VARCHAR(200) := 'Music';
    v_category2 VARCHAR(200) := 'Sports';
    v_nome_tabela VARCHAR(200) := 'tb_top_youtubers';	
BEGIN
-- 2. abertura do cursor
    OPEN cur_sports_music FOR EXECUTE format(
        'SELECT youtuber, rank
         FROM %I
         WHERE video_count >= $1 AND (category = $2 OR category = $3)',
        v_nome_tabela
    )
    USING v_video_count, v_category1, v_category2;
-- 3. recuperação de dados
    LOOP
        FETCH cur_sports_music INTO v_youtuber, v_rank;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%, %', v_youtuber, v_rank;
    END LOOP;
-- 4. fechar cursor
    CLOSE cur_sports_music;    
END;
$$

-- cursor não vinculado e sem USING, com os parâmetros dentro do SELECT:
DO $$
DECLARE
--1. Declaração
    cur_sports_music REFCURSOR;
    v_youtuber TEXT;
    v_rank INT;
    v_category VARCHAR(200); --trouxe category para conferir
BEGIN
--2. Abertura
    OPEN cur_sports_music FOR EXECUTE 
        '
        SELECT youtuber, rank, category
        FROM tb_top_youtubers 
        WHERE video_count >= 1000 AND category IN (''Music'', ''Sports'')'; --coloquei os parâmetros aqui dentro do select para testar, deu certo também
    LOOP
--3. Recuperação de dados
        FETCH cur_sports_music INTO v_youtuber, v_rank, v_category;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%, %, %', v_youtuber, v_rank, v_category; --trouxe category para conferir
    END LOOP;
--4. Fechamento
    CLOSE cur_sports_music;
END;
$$;


-- cursor vinculado (bound) 
DO $$
DECLARE
-- 1. declaração do cursor
-- vinculado
    cur_sports_music CURSOR FOR
        SELECT youtuber, rank, category --trouxe category para conferir
        FROM tb_top_youtubers
        WHERE video_count >= 1000 AND 
            (category = 'Music' 
            OR category = 'Sports'
            );
    v_youtuber VARCHAR(200);
    v_rank INT;
    v_category VARCHAR(200);
BEGIN
-- 2. abertura do cursor
    OPEN cur_sports_music;
    LOOP
-- 3. Recuperação de dados
        FETCH cur_sports_music INTO v_youtuber, v_rank, v_category;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%, %, %', v_youtuber, v_rank, v_category; --trouxe category para conferir
    END LOOP;
-- 4. Fechamento
    CLOSE cur_sports_music;
END;
$$;
