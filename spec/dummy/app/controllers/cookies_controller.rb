# frozen_string_literal: true

class CookiesController < ApplicationController
  include ActionController::Cookies
  protect_from_forgery with: :null_session
end

