# H2ocubeRailsHelper

Just an helper collection.

[![Gem Version](https://badge.fury.io/rb/h2ocube_rails_production.png)](http://badge.fury.io/rb/h2ocube_rails_production)
[![Build Status](https://travis-ci.org/h2ocube/h2ocube_rails_helper.png)](https://travis-ci.org/h2ocube/h2ocube_rails_helper)

## Installation

Add this line to your application's Gemfile:

    gem 'h2ocube_rails_helper'

And then execute:

    $ bundle
    $ rails g h2ocube_rails_helper

## Usage

    render_html_class #=> controller_name action_name controller_name_action_name devise_meta

    render_title
    render_canonical
    render_keywords
    render_description

    render_ga #=> show Google Analytics code at production (if require Garelic, will show Garelic code)

    render_seo #=> render_title << render_canonical << render_keywords << render_description << render_ga << csrf_meta_tags

## Include

* settingslogic https://github.com/binarylogic/settingslogic
* browser https://github.com/fnando/browser

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
