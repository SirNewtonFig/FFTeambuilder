# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.1/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "lodash", to: "https://ga.jspm.io/npm:lodash@4.17.21/lodash.js"
pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.51.3/dist/index.js"
pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.10.1/dist/hotkeys.esm.js"
pin "@shopify/draggable", to: "https://ga.jspm.io/npm:@shopify/draggable@1.0.0-beta.12/lib/draggable.bundle.js"
pin "@popperjs/core/dist/esm", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/dist/esm/index.js"
pin "ua-parser-js", to: "https://ga.jspm.io/npm:ua-parser-js@0.7.33/src/ua-parser.js"
pin "turbo_power" # @0.7.1
