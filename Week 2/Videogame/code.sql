
-- Section1

SELECT p.platform_name, AVG(rs.num_sales) AS Average
FROM region_sales rs
JOIN game_platform gp ON rs.game_platform_id = gp.id
JOIN platform p ON gp.platform_id = p.id
GROUP BY p.platform_name
ORDER BY Average DESC;

-- Section2

SELECT g.game_name, p.platform_name, gp.release_year, pu.publisher_name, SUM(rs.num_sales) AS global_sales
FROM game g
JOIN game_publisher gpub ON g.id = gpub.game_id
JOIN game_platform gp ON gpub.id = gp.game_publisher_id
JOIN platform p ON gp.platform_id = p.id
JOIN publisher pu ON gpub.publisher_id = pu.id
JOIN region_sales rs ON gp.id = rs.game_platform_id
GROUP BY g.game_name, p.platform_name, gp.release_year, pu.publisher_name
ORDER BY global_sales DESC
LIMIT 20;

-- Section3

SELECT g.game_name, COUNT(DISTINCT gp.platform_id) AS platform_count
FROM game g
JOIN game_publisher gpub ON g.id = gpub.game_id
JOIN game_platform gp ON gpub.id = gp.game_publisher_id
GROUP BY g.game_name
HAVING platform_count > 5
ORDER BY platform_count DESC, g.game_name ASC;

-- Section4

SELECT
    platform_name AS platform,
    genre_name AS genre,
    DENSE_RANK() OVER (PARTITION BY platform_name ORDER BY total_sales DESC) AS genre_in_platform_rank,
    total_sales AS genre_sale,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS total_rank
FROM
    (SELECT
        p.platform_name,
        gen.genre_name,
        SUM(rs.num_sales) AS total_sales
    FROM
        platform p
    JOIN
        game_platform gp ON p.id = gp.platform_id
    JOIN
        game_publisher gpub ON gp.game_publisher_id = gpub.id
    JOIN
        game g ON gpub.game_id = g.id
    JOIN
        region_sales rs ON gp.id = rs.game_platform_id
    JOIN
        genre gen ON g.genre_id = gen.id
    GROUP BY
        p.platform_name,
        gen.genre_name) AS subquery
ORDER BY
    total_sales DESC,
    platform_name,
    genre_name;

-- Section5

SELECT
    game_name,
    region_name,
    total_sales,
    rank_in_region
FROM
    (SELECT
        game_name,
        region_name,
        total_sales,
        DENSE_RANK() OVER (PARTITION BY region_name ORDER BY total_sales DESC) AS rank_in_region
    FROM
        (SELECT
            g.game_name AS game_name,
            r.region_name AS region_name,
            SUM(rs.num_sales) AS total_sales
        FROM
            game_platform gp
        JOIN
            region_sales rs ON gp.id = rs.game_platform_id
        JOIN
            game_publisher gpub ON gp.game_publisher_id = gpub.id
        JOIN
            game g ON gpub.game_id = g.id
        JOIN
            region r ON rs.region_id = r.id
        GROUP BY
            g.game_name,
            r.region_name) AS subquery1) AS subquery2
WHERE
    rank_in_region <= 10
ORDER BY
    region_name,
    rank_in_region;
-- Section6

SELECT
    g.game_name AS game_name,
    GROUP_CONCAT(p.publisher_name ORDER BY p.publisher_name ASC SEPARATOR ',') AS publishers
FROM
    game g
JOIN
    game_publisher gp ON g.id = gp.game_id
JOIN
    publisher p ON gp.publisher_id = p.id
GROUP BY
    g.game_name
HAVING
    COUNT(DISTINCT gp.publisher_id) > 1
ORDER BY
    g.game_name;