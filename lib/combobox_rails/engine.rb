require "importmap-rails"

module ComboboxRails
  class Engine < ::Rails::Engine
    isolate_namespace ComboboxRails

    initializer "combobox_rails.importmap", before: "importmap" do |app|
      # NOTE: this will add pins from this engine to the main app
      # https://github.com/rails/importmap-rails#composing-import-maps
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")

      # NOTE: something about cache; I did not look into it.
      # https://github.com/rails/importmap-rails#sweeping-the-cache-in-development-and-test
      app.config.importmap.cache_sweepers << Engine.root.join("app/javascript")
    end

    # NOTE: add engine manifest to precompile assets in production
    initializer "combobox_rails.assets.precompile" do |app|
      app.config.assets.precompile += %w[combobox_rails_manifest]
    end
  end
end
