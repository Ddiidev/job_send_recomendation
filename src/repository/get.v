module repository

import shareds.db
import entities

pub fn get_all(current_id int) ![]entities.Contact {
	mut dbase := db.ConnectionDb.new()!

	defer {
		dbase.close()
	}

	max :=  current_id + 100

	return sql dbase.conn {
		select from entities.Contact where id > current_id && id < max
	}!
}
