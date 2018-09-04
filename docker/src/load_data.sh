#!/bin/sh

psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS books"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS authors"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS titles"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS ratings"

echo "Загружаем books_edited.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS books (
    id int PRIMARY KEY,
    book_id bigint,
    books_count bigint,
    authors_id bigint,
    pub_year bigint,
    title_id bigint,
    reviews_count bigint
  );'
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy books FROM '/data/books_edited.csv' DELIMITER ';' CSV HEADER"


echo "Загружаем authors_edited.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS authors (
    id int PRIMARY KEY,
    author_name text
  );'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy authors FROM '/data/authors_edited.csv' DELIMITER ';' CSV HEADER"


echo "Загружаем titles_edited.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS titles (
    id int PRIMARY KEY,
    title text
  );'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy titles FROM '/data/titles_edited.csv' DELIMITER ';' CSV HEADER"


echo "Загружаем ratings.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS ratings (
    book_id bigint,
    user_id bigint,
    rating bigint
  );'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy ratings FROM '/data/ratings.csv' DELIMITER ',' CSV HEADER"