module main

import time
import recomendation.services

fn main() {
	println('Iniciando serviço de recomendação...')

	for {
		current_time := time.now()

		current_date := current_time.custom_format('YYYY-MM-DD')
		serven_hour_from_tomorrow := time.parse('${current_date} 00:07:00') or { time.now() }.add_days(1)

		wait_time := serven_hour_from_tomorrow - current_time

		println('Aguardando ${wait_time}s até o próximo envio...')

		$if !debug? {
			dump('Env Prod')
			time.sleep(wait_time)
		} $else $if debug? {
			dump('Env Dev')
		}

		services.send_recomendations()

		$if debug? {
			time.sleep(time.minute * 2)
		}
	}
}
