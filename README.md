# H2ocubeRailsHelper

Just an helper collection.

## Installation

Add this line to your application's Gemfile:

    gem 'garelic' # if you use render_ga
    gem 'h2ocube_rails_helper'

And then execute:

    $ bundle
    $ rails g h2ocube_rails_helper

## Usage

    render_html_class #=> controller_name action_name controller_name_action_name iPhone
    
    request.env['X_MOBILE_DEVICE'] #=> such as 'iPhone'
    
    render_title
    render_keywords
    render_description

    render_ga #=> use Garelic to show Google Analytics code at production
    
    render_seo #=> render_title << render_keywords << render_description << render_ga

## Include

* settingslogic https://github.com/binarylogic/settingslogic
* rack-mobile-detect https://github.com/talison/rack-mobile-detect
* draper https://github.com/drapergem/draper

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
