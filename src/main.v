module main

import time
import recomendation.services

fn main() {
	println('Iniciando serviço de recomendação...')
	mut is_primary_runner := true

	for {
		current_time := time.now()

		current_date := current_time.custom_format('YYYY-MM-DD')
		current_hour := current_time.hour

		mut serven_hour_today := time.parse('${current_date} 07:30:00') or { time.now() }

		range_start := time.parse('${current_date} 07:00:00') or { time.now() }
		range_end := time.parse('${current_date} 09:00:00') or { time.now() }

		// Se a hora atual for menor que 8:00, define para as 8:00 do mesmo dia
		// Se a hora atual for maior ou igual a 8:00, define para as 8:00 do dia seguinte
		if current_hour >= 9 {
			serven_hour_today = serven_hour_today.add_days(1)
		}

		mut wait_time := serven_hour_today - current_time

		if wait_time < 0 {
			serven_hour_today = serven_hour_today.add_days(1)
			wait_time = serven_hour_today - current_time
		}

		$if !debug ? {
			println('Env Prod')
			if !(current_time > range_start && current_time < range_end && is_primary_runner) {
				println('Aguardando ${wait_time}s até o próximo envio...')
				time.sleep(wait_time)
			} else if current_time > range_start && current_time < range_end && is_primary_runner {
				println('Primeira vez: Executando imediatamente por estar entre as ${range_start.custom_format('hh:mm:ss')}h e ${range_end.custom_format('hh:mm:ss')}h')
				is_primary_runner = false
			}
		} $else $if debug ? {
			println('Env Dev')
		}

		println('--> Enviando recomendações...')
		services.send_recomendations()
		println('--> Enviado')

		$if debug ? {
			if !(current_time > range_start && current_time < range_end && is_primary_runner) {
				println('Aguardando ${wait_time}s até o próximo envio...')
				time.sleep(time.minute * 2)
			} else if current_time > range_start && current_time < range_end && is_primary_runner {
				println('Primeira vez: Executando imediatamente por estar entre as ${range_start.custom_format('hh:mm:ss')}h e ${range_end.custom_format('hh:mm:ss')}h')
				is_primary_runner = false
			}
		}
	}
}
