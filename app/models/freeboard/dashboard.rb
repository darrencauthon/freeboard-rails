require 'interchangeable'

module Freeboard

  class Dashboard < ActiveRecord::Base

    serialize :data, Hash

    def self.pull_from params
      lookup_dashboard(params) || dashboard_matched_by_key(params) || a_blank_dashboard(params)
    end

    class << self

      interchangeable_describe "Your own dashboard lookup, provided params"
      interchangeable_method(:lookup_dashboard) { |params| nil }

      def dashboard_matched_by_key params
        Dashboard.where(key: params[:key]).first
      end

      def a_blank_dashboard params
        Dashboard.new(key: params[:key])
      end

    end

  end

end
