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
    it "should return the dashboard to the view" do
      dashboard = Object.new
      controller.stubs(:dashboard).returns dashboard
      controller.index
      controller.instance_eval { @dashboard }.must_be_same_as dashboard
    end
  end

  describe "dashboard" do

    let(:key) { Object.new }

    before { params[:key] = key }

    describe "no dashboards exists" do

      before do
        Freeboard::Dashboard.stubs(:where)
                            .with(key: key)
                            .returns []
      end

      it "should return a blank dashboard" do
        dashboard = controller.send(:dashboard)
        dashboard.is_a?(Freeboard::Dashboard)
        dashboard.id.nil?.must_equal true
      end

      it "should set the key" do
        dashboard = controller.send(:dashboard)
        dashboard.key.must_be_same_as key
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
        dashboard = controller.send(:dashboard)
        dashboard.must_be_same_as matching_dashboard
      end

    end

  end

end
