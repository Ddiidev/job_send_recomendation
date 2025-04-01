module models

import time
import shareds.types

pub struct LivrosGratuitosProduct {
pub:
	has_link_pdf         bool
	has_link_read_online bool
	title                string
	author               string
	overview             string
	link                 string
	current_date         time.Time
	genders              types.Genders
	thumbnail_link       types.ThumbLink
}
