module Freeboard

  class DashboardController < ApplicationController

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

    Interchangeable.define(:lookup_dashboard) { nil }

    def dashboard_matched_by_key
      Dashboard.where(key: params[:key]).first
    end

    def a_blank_dashboard
      Dashboard.new(key: params[:key])
    end

  end

end
