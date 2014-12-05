require_relative '../../../minitest_helper'

describe Freeboard::DashboardController do

  let(:controller) do
    c = Freeboard::DashboardController.new
    c.stubs(:params).returns params
    c
  end

  let(:params) { {} }

  before do
    Freeboard::Dashboard.delete_all
  end

  describe "index" do

    let(:key) { Object.new }

    before { params[:key] = key }

    describe "no dashboards exists" do

      before do
        Freeboard::Dashboard.stubs(:where)
                            .with(key: key)
                            .returns []
      end

      it "should return a blank dashboard" do
        controller.index
        dashboard = controller.instance_eval { @dashboard }
        dashboard.is_a?(Freeboard::Dashboard)
        dashboard.id.nil?.must_equal true
      end

    end

    describe "a matching dashboard exists" do

      let(:matching_dashboard) { Object.new }

      before do
        Freeboard::Dashboard.stubs(:where)
                            .with(key: key)
                            .returns [matching_dashboard]
      end

      it "should return the dashboarddashboard" do
        controller.index
        dashboard = controller.instance_eval { @dashboard }
        dashboard.must_be_same_as matching_dashboard
      end

    end

  end

end
