module entities

import time

@[table: 'Contacts']
pub struct Contact {
	id int @[primary; serial]
pub:
	whatsapp   ?string @[unique]
	email      ?string @[unique]
	updated_at time.Time
}
