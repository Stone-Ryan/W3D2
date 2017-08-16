DROP TABLE IF EXISTS users;
CREATE TABLE users (

  id INTEGER PRIMARY KEY,
  fname VARCHAR NOT NULL,
  lname VARCHAR NOT NULL
);

INSERT INTO users(
  fname,
  lname
)

VALUES ('Inhye', 'Baik'), ('Stone', 'Ryan');

DROP TABLE if exists questions;

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

FOREIGN KEY(user_id) REFERENCES users(id)
);

INSERT INTO questions(
  title,
  body,
  user_id
)

VALUES ('title 1','body 1', (SELECT id FROM users WHERE fname = 'Inhye'));
--
DROP TABLE if exists questions_follows;
CREATE TABLE questions_follows(
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY(author_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)

);
INSERT INTO questions_follows (author_id, question_id)
VALUES (
  (SELECT id FROM users WHERE fname = 'Stone' AND lname = 'Ryan'),
(SELECT id FROM questions WHERE title = 'title 1' AND body = 'body 1')
);



DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  top_level_id INTEGER,
  body TEXT NOT NULL,
  FOREIGN KEY (top_level_id) REFERENCES replies(id),
  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO replies (subject_question_id, user_id, top_level_id, body)
VALUES
((SELECT id FROM questions WHERE title='title 1'),
(SELECT id FROM users WHERE fname = 'Stone'),
NULL,
'Hi, I''m Stone, is anyone here?');

INSERT INTO replies (subject_question_id, user_id, top_level_id, body)
VALUES
((SELECT id FROM questions WHERE title='title 1'),
(SELECT id FROM users WHERE fname='Inhye'),
(SELECT id FROM replies WHERE body='Hi, I''m Stone, is anyone here?'),
'I am!! My name is Inhye!'
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);
INSERT INTO question_likes (user_id, question_id) VALUES (1, 1);
INSERT INTO question_likes (user_id, question_id) VALUES (1, 2);
