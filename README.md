# Combobox Rails

NOTICE: Pre-alpha. This gem in is in progress of being migrated out of a
separate repo and needs work before it can be included in other projects.

To make rendering the [combobox pattern] with a dynamic [listbox] easy to
access and extend.

[combobox pattern]: https://www.w3.org/WAI/ARIA/apg/patterns/combobox/
[listbox]: https://www.w3.org/WAI/ARIA/apg/patterns/listbox/

## Features

TODO

## Path to being a "Real Gem"

- Figure out where dependencies live (how does gemspec x Gemfile work?)
- Reduce dependencies on other gems
    - View component -> other lib to generate HTML (view component is heavy)
    - turbo-rails (can we just use turbo?)
    - stimulus-rails (same here?)
    - sprockets -> propshaft (lighter weight lib)
    - heroicon -> static svgs? options to replace?
- Clean up the API
    - Ideally this looks a lot like a rails form field, roughly:

    ```erb
    <%= f.combobox :task_id, collection: collection %>

    <%= f.combobox :task_id, refresh_url: url, ...options do |combobox| %>
        <%= combobox.with_listbox do |listbox| %>
            <% @tasks.each do |task| %>
                <%= listbox.with_option(id: task.id) do |option| %>
                    ... # rendering option, option to specify how to render selected variant
                <% end %>
            <% end %>
        <% end %>
    <% end %>
    ```
- Migrate tests
- CI after testing is setup

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "combobox_rails"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install combobox_rails
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
