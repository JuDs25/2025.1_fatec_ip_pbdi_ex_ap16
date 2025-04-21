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