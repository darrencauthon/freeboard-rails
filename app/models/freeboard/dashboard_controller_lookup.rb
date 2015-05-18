require 'interchangeable'

module Freeboard

  module DashboardControllerLookup
  
    def self.included(receiver)

      receiver.instance_eval do

        interchangeable_describe "Your own dashboard lookup, provided params"
        interchangeable_method(:lookup_dashboard) { nil }

        def dashboard
          lookup_dashboard || dashboard_matched_by_key || a_blank_dashboard
        end

        def dashboard_matched_by_key
          Dashboard.where(key: params[:key]).first
        end

        def a_blank_dashboard
          Dashboard.new(key: params[:key])
        end

      end

    end

  end

end
