pin "combobox-rails", preload: true
pin "@hotwired/turbo-rails", to: "turbo.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@github/combobox-nav", to: "https://ga.jspm.io/npm:@github/combobox-nav@2.3.0/dist/index.js"
pin "lodash.debounce", to: "https://ga.jspm.io/npm:lodash.debounce@4.0.8/index.js"

pin_all_from(
  File.expand_path("../app/javascript/combobox-controllers", __dir__),
  under: "combobox-controllers"
)
