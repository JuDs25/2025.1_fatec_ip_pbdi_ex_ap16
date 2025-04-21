

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
BEGIN
--2. Abertura
    OPEN cur_sports_music FOR EXECUTE '
        SELECT youtuber, rank 
        FROM tb_top_youtubers 
        WHERE video_count >= 1000 AND category IN (''Music'', ''Sports'')'; --coloquei os parâmetros aqui dentro do select para testar, deu certo também
    LOOP
--3. Recuperação de dados
        FETCH cur_sports_music INTO v_youtuber, v_rank;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%, %', v_youtuber, v_rank;
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
        SELECT youtuber, rank
        FROM tb_top_youtubers
        WHERE video_count >= 1000 AND (category = 'Music' OR category = 'Sports');
    v_youtuber VARCHAR(200);
    v_rank INT;
BEGIN
-- 2. abertura do cursor
    OPEN cur_sports_music;
    LOOP
-- 3. Recuperação de dados
        FETCH cur_sports_music INTO v_youtuber, v_rank;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%, %', v_youtuber, v_rank;
    END LOOP;
-- 4. Fechamento
    CLOSE cur_sports_music;
END;
$$;