WITH player_battles AS (SELECT
                            p.player_id
                          , sbd.start_timestamp
                          , str.result
                          , ROW_NUMBER() OVER (PARTITION BY p.player_id ORDER BY sbd.start_timestamp) AS rn
FROM Hub_Player p
JOIN L_Battle_Participance pbt ON p.player_hk = pbt.player_hk
JOIN H_Team t ON pbt.team_hk = t.team_hk
JOIN L_Battle_Team bt ON t.team_hk = bt.team_hk
JOIN Sat_Battle_Team str ON bt.battle_team_hk = str.battle_team_hk
        AND str.row_actual_to IS NULL
JOIN H_Battle b ON bt.battle_hk = b.battle_hk
JOIN Sat_Battle_Duration sbd ON sbd.battle_hk = b.battle_hk
        AND sbd.row_actual_to IS NULL
-- WHERE sbd.start_timestamp >= current_date - INTERVAL 'N days' -- Uncomment this line to filter battles from the last N days
)
, wins AS (SELECT
              player_id
            , start_timestamp
            , result
            , ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY start_timestamp) AS w_rn
FROM player_battles
WHERE result = 'win'
)
, grouped AS (SELECT
                 p.player_id
               , p.start_timestamp
               , p.result
               , p.rn - w.w_rn AS w_group
FROM player_battles p
JOIN wins w ON p.player_id = w.player_id AND p.start_timestamp = w.start_timestamp
)
SELECT
    p.player_id
  , COALESCE(max(w.cnt), 0) AS max_win_streak
FROM player_battles p
LEFT JOIN (
    SELECT
      player_id
    , w_group  AS win_streak
    , COUNT(*) AS cnt
    FROM grouped
    GROUP BY player_id, w_group
) w ON p.player_id = w.player_id
GROUP BY 1;
