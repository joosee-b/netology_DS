#!/bin/sh

psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS books"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS authors"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS titles"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS ratings"


echo "Загружаем authors_edited.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS authors (
    id bigint PRIMARY KEY,
    author_name text
  );'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy authors FROM '/data/authors_edited.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем titles_edited.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS titles (
    id bigint PRIMARY KEY,
    title text
  );'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy titles FROM '/data/titles_edited.csv' DELIMITER ';' CSV HEADER"


echo "Загружаем books_edited.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS books (
    id bigint PRIMARY KEY,
    books_count bigint,
    authors_id bigint REFERENCES authors (id),
    pub_year bigint,
    title_id bigint REFERENCES titles (id),
    reviews_count bigint
  );'
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy books FROM '/data/books_edited.csv' DELIMITER ';' CSV HEADER"


echo "Загружаем ratings.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS ratings (
    book_id bigint REFERENCES books (id),
    user_id bigint,
    rating bigint
  );'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy ratings FROM '/data/ratings.csv' DELIMITER ',' CSV HEADER"