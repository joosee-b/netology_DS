
-- Запрос 1 - Вывести авторов по годам публикаций
SELECT author_name, pub_year
FROM books
JOIN authors ON  books.authors_id = authors.id
ORDER BY pub_year ASC
LIMIT 10;

-- Запрос 2 - Вывести первый и последний год публикации авторов
WITH t_authors_years as
	(SELECT authors_id, 
		MIN (pub_year) as first_year_pub,
		max (pub_year) as last_year_pub
		FROM books
		GROUP BY authors_id
	)
	SELECT author_name, first_year_pub, last_year_pub
		FROM t_authors_years
		JOIN authors ON t_authors_years.authors_id = authors.id
LIMIT 10;

-- Запрос 3 - Вывести список книг по количеству рецензий
SELECT title, reviews_count
FROM books
JOIN titles ON books.book_id = titles.id
ORDER BY reviews_count DESC
LIMIT 10;

-- Запрос 4 - Вывести средний рейтинг по пользователям, для пользователей, которые голосовали больше, чем за 10 фильмов и средний рейтинг у которых больше 2, но меньше 5, чтобы откинуть пользователей, голосовавших одинаково
SELECT user_id, 
	AVG(rating) as avg_rating,
	COUNT(user_id) as count_user
FROM ratings
GROUP BY user_id
HAVING COUNT(user_id) > 10 AND AVG(rating) > 2 AND AVG(rating) < 5
ORDER BY avg_rating ASC
LIMIT 10;

-- Запрос 5 - Вывести список книг по среднему рейтингу
WITH t_avg_rating_books as
	(SELECT DISTINCT book_id,
		AVG(rating) as avg_rating
			FROM ratings
			GROUP BY book_id
	)
	SELECT title, avg_rating
		FROM t_avg_rating_books
		JOIN titles
		ON t_avg_rating_books.book_id = titles.id
	ORDER BY avg_rating DESC
	LIMIT 10;

-- Запрос 6 - Вывести список авторов по общему количеству рецензий по написанным автором книгам
SELECT DISTINCT author_name,
	SUM(reviews_count) OVER (PARTITION BY authors_id) as count_reviews_author
FROM books
	JOIN authors ON books.authors_id = authors.id
ORDER BY count_reviews_author ASC
LIMIT 10;

-- Запрос 7 - Вывести список авторов и количество книг, написанных каждым автором
WITH t_count_books as
	(SELECT DISTINCT authors_id,
		COUNT(book_id) as count_books
			FROM books
			GROUP BY authors_id
	)
	SELECT author_name, count_books
		FROM t_count_books
		JOIN authors ON t_count_books.authors_id = authors.id
	ORDER BY count_books DESC
	LIMIT 10;

-- Запрос 8 - Вывести количество оценок у каждой книги
WITH t_count_rating_books as
	(SELECT DISTINCT book_id,
		COUNT(rating) as count_rating
			FROM ratings
			GROUP BY book_id
	)
	SELECT title, count_rating
		FROM t_count_rating_books
		JOIN titles ON t_count_rating_books.book_id = titles.id
	ORDER BY count_rating ASC
	LIMIT 10;

-- Запрос 9 - Вывести количество оценок у каждого автора по всем написанным книгам
WITH t_count_rating_books as
	(SELECT DISTINCT ratings.book_id, authors_id,
		COUNT(rating) OVER (PARTITION BY ratings.book_id) as count_rating
		FROM ratings
		JOIN books ON ratings.book_id = books.book_id
	)
	SELECT DISTINCT author_name, 
		SUM (count_rating) OVER (PARTITION BY authors_id) as count_rating_author
		FROM t_count_rating_books
		JOIN authors ON t_count_rating_books.authors_id=authors.id
	ORDER BY count_rating_author DESC
	LIMIT 10;

-- Запрос 10 - Вывести средний рейтинг авторов по среднему рейтингу всех написанных автором книг
WITH t_books_authors_rating as
	(SELECT DISTINCT books.book_id, books.authors_id,
		AVG(rating) OVER (PARTITION BY ratings.book_id) as avg_rating
	FROM ratings
		JOIN books
		ON ratings.book_id = books.book_id
	)
	SELECT DISTINCT author_name, 
		AVG(avg_rating) OVER (PARTITION BY t_books_authors_rating.authors_id) as avg_rating_author
		FROM t_books_authors_rating
		JOIN authors ON t_books_authors_rating.authors_id = authors.id
	ORDER BY avg_rating_author DESC
	LIMIT 10;