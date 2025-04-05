module repository

import entities
import shareds.db
import shareds.utils

pub fn get_all(current_id int) ![]entities.Contact {
	mut dbase := db.ConnectionDb.new()!

	defer {
		dbase.close()
	}

	max := current_id + 100

	start, end := utils.get_date_start_and_end()

	return sql dbase.conn {
		select from entities.Contact where id > current_id && id < max
		&& (latest_recomendation_at is none || (latest_recomendation_at > start
		&& latest_recomendation_at < end))
	} or {
		eprintln(err)
		return []entities.Contact{}
	}
}
