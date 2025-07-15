WITH player_battles AS (
SELECT
    p.player_id,
    sbp.damage_dealed,
    str.result,
    sbd.start_timestamp,
    b.battle_hk,
    SUM(CASE WHEN str.result = 'win' THEN 1 ELSE 0 END) OVER (PARTITION BY p.player_id, sbd.start_timestamp::date ORDER BY sbd.start_timestamp) AS wins_per_day,
    SUM(CASE WHEN str.result = 'lose' THEN 1 ELSE 0 END) OVER (PARTITION BY p.player_id, sbd.start_timestamp::date ORDER BY sbd.start_timestamp) AS loses_per_day,
    min(CASE WHEN str.result = 'draw' THEN sbd.start_timestamp END) OVER (PARTITION BY p.player_id, sbd.start_timestamp::date) AS first_draw_per_date
FROM H_Player p
JOIN L_Battle_Participance pbt ON p.player_hk = pbt.player_hk
JOIN Sat_Battle_Perfomance sbp ON pbt.battle_participant_hk = sbp.battle_participant_hk
        AND sbp.row_actual_to IS NULL
JOIN H_Team t ON pbt.team_hk = t.team_hk
JOIN L_Battle_Team bt ON t.team_hk = bt.team_hk
JOIN Sat_Battle_Team str ON bt.battle_team_hk = str.battle_team_hk
        AND str.row_actual_to IS NULL
JOIN H_Battle b ON bt.battle_hk = b.battle_hk
JOIN Sat_Battle_Duration sbd ON sbd.battle_hk = b.battle_hk
        AND sbd.row_actual_to IS NULL
), kills as (
SELECT
  p.player_id
, p.start_timestamp::date             AS battle_date
, COUNT(destr.battle_player_destr_hk) AS kills_per_day
FROM player_battles p
LEFT JOIN L_Battle_Player_Destroyer destr ON p.player_id = destr.destroyer_player_hk AND p.battle_hk = destr.battle_hk
        AND destr.row_actual_to IS NULL
WHERE p.loses_per_day = 3
  AND p.result = 'lose'
GROUP BY p.player_id, p.start_timestamp::date
)
SELECT
    pb.player_id
  , pb.start_timestamp::date AS battle_date
  , pb.first_draw_per_date
  , k.kills_per_day as kills_per_day_in_3rd_loss
  , MAX(CASE WHEN pb.wins_per_day = 7 AND pb.result = 'win' THEN pb.damage_dealed END) AS damage_dealed_in_7th_win
FROM player_battles pb
LEFT JOIN kills k ON pb.player_id = k.player_id AND pb.start_timestamp::date = k.battle_date
GROUP BY pb.player_id, pb.start_timestamp::date, pb.first_draw_per_date, k.kills_per_day;