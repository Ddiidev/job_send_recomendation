module main

import time
import recomendation.services

fn main() {
	println('Iniciando serviço de recomendação...')

	for {
		current_time := time.now()

		current_date := current_time.custom_format('YYYY-MM-DD')
		current_hour := current_time.hour
		
		mut serven_hour_today := time.parse('${current_date} 07:00:00') or { time.now() }
		
		// Se a hora atual for menor que 8:00, define para as 8:00 do mesmo dia
		// Se a hora atual for maior ou igual a 8:00, define para as 8:00 do dia seguinte
		if current_hour >= 8 {
			serven_hour_today = serven_hour_today.add_days(1)
		}

		mut wait_time := serven_hour_today - current_time

		if wait_time < 0 {
			serven_hour_today = serven_hour_today.add_days(1)
			wait_time = serven_hour_today - current_time
		}

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
