import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.ComboboxStimulus = application

// Eager load all controllers defined in the import map under controllers/**/*_controller
eagerLoadControllersFrom("combobox-controllers", application)
console.log("LOADED combobox-controllers")
