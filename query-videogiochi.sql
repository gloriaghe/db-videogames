--QUERY SELECT

--1- Selezionare tutte le software house americane (3)
select * 
FROM software_houses
WHERE country = 'United States';
--2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
select *
FROM players 
WHERE city = 'Rogahnland';
--3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
select *
FROM players 
WHERE name like '%a';
--4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
select *
FROM reviews 
WHERE player_id = 800;
--5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
select count(*)
FROM tournaments
WHERE year = 2015;
--6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
select *
FROM awards
WHERE description like '%facere%';
--7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
select  videogame_id
FROM category_videogame
WHERE category_id = 2 OR category_id = 6
GROUP BY videogame_id;
--8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
select *
FROM reviews
WHERE rating >= 2 AND rating <= 4;
--9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
select *
FROM videogames
WHERE release_date like '2020%';
--10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
select videogame_id 
FROM reviews
WHERE rating = 5
GROUP BY videogame_id;
--*********** BONUS ***********

--11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)
select count(*) number, avg(rating) media
FROM reviews
WHERE videogame_id = 412;

--12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13
select count(*) number
FROM videogames
WHERE software_house_id = 1
AND DATEPART(year, release_date) = 2018;

--QUERY CON GROUPBY

--1- Contare quante software house ci sono per ogni paese (3)
select country, count(*) number
FROM software_houses
GROUP BY country;
--2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
select videogame_id, count(*) number 
FROM reviews
GROUP BY videogame_id
ORDER BY videogame_id;
--3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
select pegi_label_id, count(*) number 
FROM pegi_label_videogame
GROUP BY pegi_label_id;
--4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
select DATEPART(year, release_date) year, count(*) number
FROM videogames
GROUP BY DATEPART(year, release_date);

--5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
select device_id, count(*) number
FROM device_videogame 
GROUP BY device_id;
--6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
select videogame_id, avg(rating) media
FROM reviews
GROUP BY videogame_id
ORDER BY videogame_id;

--QUERY CON JOIN

--1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)

Select distinct players.id, players.name, players.lastname
from reviews
INNER JOIN players on player_id = players.id;
--2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
Select distinct videogames.id, videogames.name
from tournaments
INNER JOIN tournament_videogame ON tournament_videogame.tournament_id = tournaments.id
INNER JOIN videogames on tournament_videogame.videogame_id = videogames.id
WHERE tournaments.year = 2016;
--3- Mostrare le categorie di ogni videogioco (1718)
select distinct videogames.id, videogames.name, categories.name
FROM categories
INNER JOIN category_videogame ON category_videogame.category_id = categories.id
INNER JOIN videogames ON category_videogame.videogame_id = videogames.id;
--4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
select distinct software_houses.id, software_houses.name, software_houses.tax_id, software_houses.city, software_houses.country
FROM software_houses
INNER JOIN videogames ON videogames.software_house_id =  software_houses.id
WHERE DATEPART(year, videogames.release_date) >= 2018;
--5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
select awards.name, software_houses.name
FROM software_houses
INNER JOIN videogames ON software_houses.id = videogames.software_house_id
INNER JOIN award_videogame ON videogames.id = award_videogame.videogame_id
INNER JOIN awards ON award_videogame.award_id = awards.id
ORDER BY software_houses.id;

--6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
-- da controllare!!!!
SELECT DISTINCT videogames.name, categories.name, pegi_labels.name
FROM categories
INNER JOIN category_videogame ON category_videogame.category_id = categories.id
INNER JOIN videogames ON videogames.id = category_videogame.videogame_id
INNER JOIN pegi_label_videogame ON pegi_label_videogame.videogame_id = videogames.id
INNER JOIN pegi_labels ON pegi_labels.id = pegi_label_videogame.pegi_label_id
INNER JOIN reviews ON videogames.id = reviews.videogame_id
WHERE reviews.rating <= 4
GROUP BY videogames.name, categories.name, pegi_labels.name
ORDER BY videogames.name;
--7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT videogames.name, videogames.id
FROM videogames
INNER JOIN tournament_videogame ON tournament_videogame.videogame_id = videogames.id
INNER JOIN tournaments ON tournaments.id = tournament_videogame.tournament_id
INNER JOIN player_tournament ON player_tournament.tournament_id = tournaments.id
INNER JOIN players ON players.id = player_tournament.player_id
WHERE players.name like 's%';
--8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT DISTINCT tournaments.city
from tournaments 
INNER JOIN tournament_videogame ON tournament_videogame.tournament_id = tournaments.id
INNER JOIN videogames ON videogames.id = tournament_videogame.videogame_id
INNER JOIN award_videogame ON award_videogame.videogame_id = videogames.id
INNER JOIN awards ON awards.id = award_videogame.award_id
--WHERE awards.name = 'Gioco dell%' AND award_videogame.year = '2018';
WHERE awards.id = 1 AND award_videogame.year = '2018';
--9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
SELECT DISTINCT tournaments.name, players.*
FROM tournaments
INNER JOIN player_tournament ON tournaments.id = player_tournament.tournament_id
INNER JOIN players ON player_tournament.player_id = players.id
INNER JOIN tournament_videogame ON tournaments.id = tournament_videogame.tournament_id
INNER JOIN videogames ON videogames.id = tournament_videogame.videogame_id
INNER JOIN award_videogame ON award_videogame.videogame_id = videogames.id
INNER JOIN awards ON awards.id = award_videogame.award_id
WHERE awards.name = 'Gioco più atteso' AND award_videogame.year = '2018' AND tournaments.year = '2019';

--*********** BONUS ***********

--10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)
SELECT TOP 1 software_houses.*, videogames.*
FROM software_houses
INNER JOIN videogames ON software_houses.id = videogames.software_house_id
ORDER BY videogames.release_date ASC;

--11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)
SELECT TOP 1 videogames.id, videogames.name, videogames.release_date, count(*) as [number_review]
FROM videogames
INNER JOIN reviews ON reviews.videogame_id = videogames.id
GROUP BY videogames.id, videogames.name, videogames.release_date
ORDER BY number_review DESC;

--12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)
SELECT TOP 1 software_houses.id, software_houses.name, count(*) as [number_awards]
FROM software_houses
INNER JOIN videogames ON software_houses.id = videogames.software_house_id
INNER JOIN award_videogame ON videogames.id = award_videogame.videogame_id
WHERE award_videogame.year >= '2015' AND award_videogame.year <= '2016'
GROUP BY software_houses.id, software_houses.name
ORDER BY number_awards DESC;

--13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 1.5 (10)