require_relative '../../../minitest_helper'

class TestFreeboardDashboardController
  include Freeboard::DashboardControllerLookup
end

describe Freeboard::DashboardControllerLookup do

  describe "pull from params" do

    let(:params) { {} }
    let(:key)    { Object.new }

    before do
      params[:key] = key
      TestFreeboardDashboardController.stubs(:params).returns params
      TestFreeboardDashboardController.stubs(:lookup_dashboard).returns nil
    end

    describe "no dashboards exists" do

      before do
        Freeboard::Dashboard.stubs(:where)
                            .with(key: key)
                            .returns []
      end

      it "should return a blank dashboard" do
        dashboard = TestFreeboardDashboardController.dashboard
        dashboard.is_a?(Freeboard::Dashboard)
        dashboard.id.nil?.must_equal true
      end

      it "should set the key" do
        dashboard = TestFreeboardDashboardController.dashboard
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

      describe "but the dashboard lookup returned nothing" do

        it "should return the dashboard" do
          dashboard = TestFreeboardDashboardController.dashboard
          dashboard.must_be_same_as matching_dashboard
        end

      end

      describe "but the dashboard lookup returned something" do

        let(:something) { Object.new }

        before do
          Freeboard::Dashboard.stubs(:lookup_dashboard).returns something
        end

        it "should return that something" do
          dashboard = TestFreeboardDashboardController.dashboard
          dashboard.must_be_same_as something
        end

      end

    end

  end

  describe "lookup dashboard" do

    it "should return nil" do
      TestFreeboardDashboardController.send(:lookup_dashboard).nil?.must_equal true
    end

    it "should be an interchangeable method" do
      Interchangeable.methods.select do |method|
        method.target == Freeboard::DashboardControllerLookup &&
        method.method_name == :lookup_dashboard
      end
    end

    it "should describe what the method is for" do
      Interchangeable.methods.select do |method|
        method.target == Freeboard::DashboardControllerLookup &&
        method.method_name == :lookup_dashboard &&
        method.description == 'Your own dashboard lookup'
      end

    end

  end

end
