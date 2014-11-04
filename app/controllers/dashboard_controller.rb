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
    @dashboard ||= Dashboard.where(key: params[:key]).first || Dashboard.new(key: params[:key])
  end

end
