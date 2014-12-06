require 'interchangeable'

module Freeboard

  class DashboardController < ApplicationController

    protect_from_forgery :except => [:save_board]

    def index
      @dashboard = Dashboard.pull_from params
    end

    def save_board
      dashboard = Dashboard.pull_from params
      dashboard.data = JSON.parse params[:data]
      dashboard.save
      render json: { data: dashboard.data }
    end

    def get_board
      dashboard = Dashboard.pull_from params
      render json: { data: dashboard.data }
    end

  end

end
