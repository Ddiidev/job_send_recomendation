module services

import shareds.logger
import netflix.models as netflix_models
import repository as contact_repository
import recomendation.services.email_builders
import recomendation.services.whtasapp_builders
import amazon.controllers as amazon_controllers
import netflix.controllers as netflix_controllers
import instant_gaming.models as instant_gaming_models
import livros_gratuitos.models as livros_gratuitos_models
import mercado_livre_play.models as mercado_livre_play_models
import instant_gaming.controllers as instant_gaming_controllers
import livros_gratuitos.controllers as livros_gratuitos_controllers
import mercado_livre_play.controllers as mercado_livre_play_controllers

pub fn send_recomendations() {
	mut threads := []thread{}
	mut log := logger.Logger.new('-test-', '-test-')

	contatcs := contact_repository.get_all(0) or { return }
	amazon_products := amazon_controllers.get_recomendation(mut log) or { [] }
	netflix_product := netflix_controllers.get_recomendation(mut log) or {
		netflix_models.NetflixProduct{}
	}
	instangaming_product := instant_gaming_controllers.get_recomendation(mut log) or {
		instant_gaming_models.InstantGamingProduct{}
	}
	livros_gratuitos_product := livros_gratuitos_controllers.get_recomendation(mut log) or {
		livros_gratuitos_models.LivrosGratuitosProduct{}
	}
	mercado_livre_play_product := mercado_livre_play_controllers.get_recomendation(mut log) or {
		mercado_livre_play_models.MercadoLivrePlayProduct{}
	}

	for contact in contatcs {
		if threads.len == 4 {
			threads.wait()
			threads = []
		}

		if whatsapp := contact.whatsapp {
			dump('Enviando via whatsapp (add a pilha de threads)')
			threads << go whtasapp_builders.build_all_recommendations(contact.id, whatsapp,
				amazon_products, instangaming_product, livros_gratuitos_product, mercado_livre_play_product,
				netflix_product)
			dump('Adicionado na pilha de threads')
		}
		if email := contact.email {
			dump('Enviando via email (add a pilha de threads)')
			threads << go email_builders.build_all_recommendations(contact.id, email,
				amazon_products, instangaming_product, livros_gratuitos_product, mercado_livre_play_product,
				netflix_product)
			dump('Adicionado na pilha de threads')
		}
	}

	if threads.len > 0 {
		threads.wait()
	}
}
