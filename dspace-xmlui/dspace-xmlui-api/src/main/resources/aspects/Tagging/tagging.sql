CREATE SEQUENCE eperson_item2tag_seq;

CREATE TABLE eperson_item2tag
(
  tag_id            INTEGER PRIMARY KEY,
  eperson_id        INTEGER REFERENCES eperson(eperson_id),
  item_id           INTEGER REFERENCES item(item_id),
  tag_name          VARCHAR(32)
);

CREATE INDEX eperson_item2tag_eperson_fk_idx ON eperson_item2tag(eperson_id);
CREATE INDEX eperson_item2tag_item_fk_idx ON eperson_item2tag(item_id);
CREATE INDEX eperson_item2tag_tag_idx ON eperson_item2tag(tag_name);
