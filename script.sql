-- cursor que exiba as variáveis rank e youtuber de toda tupla que tiver video_count pelo menos igual a 1000 e cuja category seja igual a 'Sports' ou 'Music'
DO $$
DECLARE
-- 1. declaração do cursor
-- não vinculado
    cur_sports_music REFCURSOR;
    v_youtuber VARCHAR(200);
	v_rank INT;
    v_video_count INT := 1000;
    v_category VARCHAR(200);
	v_nome_tabela VARCHAR(200) := 'tb_top_youtubers';	
BEGIN
-- 2. abertura do cursor
	-- 'for execute' vamos usar para tabelas dinâmicas
	-- '%s' a mesmo coisa que f'SELECT...{v_nome_tabela}'
    OPEN cur_sports_music FOR EXECUTE format (
        '
        SELECT youtuber, rank
        FROM %s
        WHERE STARTED >= %s', 
        v_nome_tabela, v_video_count
    );
-- 3. recuperação de dados
    LOOP
        FETCH cur_sports_music INTO
            v_youtuber;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%, %', v_youtuber, v_rank;
    END LOOP;
-- 4. fechar cursor
	CLOSE cur_sports_music;    
END;
$$