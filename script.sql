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