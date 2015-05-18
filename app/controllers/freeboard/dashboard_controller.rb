require 'interchangeable'

module Freeboard

  class DashboardController < ApplicationController

    interchangeable_describe "Your own dashboard lookup"
    interchangeable_method(:lookup_dashboard) { nil }

    protect_from_forgery :except => [:save_board]

    def index
      @dashboard = dashboard
    end

    def save_board
      dashboard.data = JSON.parse params[:data]
      dashboard.save
      render json: { data: dashboard.data }
    end

    def get_board
      render json: { data: dashboard.data }
    end

    private

    def dashboard
      @dashboard ||= lookup_dashboard || dashboard_matched_by_key || a_blank_dashboard
    end

    def dashboard_matched_by_key
      Dashboard.where(key: params[:key]).first
    end

    def a_blank_dashboard
      Dashboard.new(key: params[:key])
    end

    def authenticate
      d = dashboard
      if dashboard.requires_authentication?
        authenticate_or_request_with_http_basic 'auth' do |username, password|
          username == d.credentials[:username] && password == d.credentials[:password]
        end
      end
    end

  end

end
