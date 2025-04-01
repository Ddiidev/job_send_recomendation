module main

import time
import recomendation.services

fn main() {
	for {
		current_time := time.now()

		current_date := current_time.custom_format('YYYY-MM-DD')
		serven_hour_from_tomorrow := time.parse('${current_date} 00:07:00') or {
			time.now()
		}.add_days(1)

		wait_time := serven_hour_from_tomorrow - current_time

		time.sleep(wait_time)

		services.send_recomendations()

		// time.sleep(time.second * 20)
	}
}
