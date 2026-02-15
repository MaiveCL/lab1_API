// Configure your import map in config/importmap.rb
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

// Désactive Turbo Drive (navigation automatique)
Turbo.session.drive = false
