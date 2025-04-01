module services

import shareds.logger
import wpapi.services as wpapi_services
import repository as contact_repository
import amazon.controllers as amazon_controllers

// import netflix.controllers as netflix_controllers
// import instant_gaming.controllers as instant_gaming_controllers
// import livros_gratuitos.controllers as livros_gratuitos_controllers
// import mercado_livre_play.controllers as mercado_livre_play_controllers
pub fn send_recomendations() {
	mut threads := []thread{}
	mut log := logger.Logger.new('-test-', '-test-')

	contatcs := contact_repository.get_all(0) or { return }
	mut amazon := amazon_controllers.get_recomendation(mut log) or { return }[0] or { return }

	for contact in contatcs {
		if threads.len > 4 {
			threads.wait()
			threads = []
		}

		if contact.whatsapp != none {
			threads << go fn [contact, mut amazon] () {
				mut text := 'Plataforma: *Amazon*\n'
				text += 'Título: *${amazon.title}*\n'
				text += 'Avaliação: *${amazon.geral_evaluation}*\n'
				text += 'Sinopse: _${amazon.sinopse.trim_space()}_\n'
				text += 'Preço: *${amazon.price_printed or { 0.00 }}*\n'
				text += 'Preço digital: *${amazon.price_kindle_ebook or { 0.00 }}*\n'
				text += 'Link: *${amazon.link}*\n'

				wpapi_services.send_image(
					to:  contact.whatsapp or { return }
					url: amazon.images_links
				) or {}

				wpapi_services.send_text(
					to:   contact.whatsapp or { return }
					text: text
				) or {}
			}()
		}
	}

	threads.wait()
}
