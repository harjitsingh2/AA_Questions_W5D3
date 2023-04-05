PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    reply TEXT NOT NULL,
    parent_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    like_question BOOLEAN,  /* should this be not null? */

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

/* Add data */

INSERT INTO
    users (fname, lname)
VALUES
    ('Jeremy', 'Liang'),
    ('Harjit', 'Singh'),
    ('Kyle', 'Ginzburg');

INSERT INTO
    questions (title, body, user_id)
VALUES
    ('Creating tables', 'How do I make a table in SQL?', (SELECT id FROM users WHERE fname = 'Harjit')),
    ('Naptime?', 'Am I sleeping right now?', (SELECT id FROM users WHERE fname = 'Jeremy')),
    ('Are you sleeping?', 'Did you not get enough sleep last night?', (SELECT id FROM users WHERE fname = 'Kyle'));


INSERT INTO 
    replies (question_id, user_id, reply, parent_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Are you sleeping?'), (SELECT id FROM users WHERE fname = 'Jeremy'), 'Yes.', NULL),
    ((SELECT id FROM questions WHERE title = 'Are you sleeping?'), (SELECT id FROM users WHERE fname = 'Kyle'), 'Go get some coffee.', 1);

INSERT INTO 
    replies (question_id, user_id, reply, parent_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Are you sleeping?'), (SELECT id FROM users WHERE fname = 'Jeremy'), 'I already had coffee.', (SELECT id FROM replies WHERE id = 1));

INSERT INTO 
    question_follows (user_id, question_id)
VALUES  
    ((SELECT id FROM users WHERE fname = 'Harjit'), (SELECT id FROM questions WHERE title = 'Creating tables')), 
    ((SELECT id FROM users WHERE fname = 'Jeremy'), (SELECT id FROM questions WHERE title = 'Naptime?')),
    ((SELECT id FROM users WHERE fname = 'Kyle'), (SELECT id FROM questions WHERE title = 'Are you sleeping?'));

INSERT INTO
    question_likes (user_id, question_id, like_question)
VALUES
    (3, 1, TRUE),
    (2, 2, TRUE),
    (3, 2, FALSE);