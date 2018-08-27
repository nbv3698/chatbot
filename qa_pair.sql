ALTER TABLE member ADD
(
	role_id INT(1)
);

INSERT INTO member(NAME, PASSWORD, email, active, role_id)
VALUES('admin', '202cb962ac59075b964b07152d234b70', 'admin@mail.com', 1, 1);


CREATE TABLE `qa_pair` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `question` VARCHAR(255) DEFAULT NULL,
  `count` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MYISAM DEFAULT CHARSET=latin1;