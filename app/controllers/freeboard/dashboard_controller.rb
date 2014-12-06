require 'interchangeable'

module Freeboard

  class DashboardController < ApplicationController

    interchangeable_describe "Your own dashboard lookup"
    interchangeable_method(:lookup_dashboard) { nil }

    protect_from_forgery :except => [:save_board]

    def index
      @dashboard = lookup_dashboard || dashboard_matched_by_key || a_blank_dashboard
    end

    def save_board
      dashboard = lookup_dashboard || dashboard_matched_by_key || a_blank_dashboard
      dashboard.data = JSON.parse params[:data]
      dashboard.save
      render json: { data: dashboard.data }
    end

    def get_board
      dashboard = lookup_dashboard || dashboard_matched_by_key || a_blank_dashboard
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

  end

end
