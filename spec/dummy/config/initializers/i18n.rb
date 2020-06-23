# frozen_string_literal: true

I18n.exception_handler = lambda do |exception, locale, key, options|
  raise exception
end
