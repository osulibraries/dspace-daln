CREATE SEQUENCE lists_seq;

CREATE TABLE lists
(
  list_id        INTEGER PRIMARY KEY,
  eperson_id     INTEGER REFERENCES eperson(eperson_id),
  list_name      VARCHAR(128),
  list_comment   VARCHAR,
  shared         BOOLEAN
);

CREATE INDEX lists_eperson_fk_idx ON lists(eperson_id);

CREATE SEQUENCE list_entries_seq;

CREATE TABLE list_entries
(
  entry_id       INTEGER PRIMARY KEY,
  list_id        INTEGER REFERENCES lists(list_id),
  ordernum       INTEGER,
  item_id        INTEGER REFERENCES item(item_id)
);

CREATE INDEX list_entries_list_fk_idx ON list_entries(list_id);
CREATE INDEX list_entries_ordernum_idx ON list_entries(ordernum);
