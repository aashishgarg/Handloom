class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_filter :prepare_unobtrusive_flash
end
