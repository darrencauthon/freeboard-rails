require_relative '../../../minitest_helper'

describe Freeboard::Dashboard do
  it "should let me do something" do
    Freeboard::Dashboard.delete_all
    Freeboard::Dashboard.create
    Freeboard::Dashboard.count.must_equal 1
  end

  describe "pull from params" do

    let(:params) { {} }
    let(:key)    { Object.new }

    before do
      params[:key] = key
      Freeboard::Dashboard.stubs(:lookup_dashboard).with(params).returns nil
    end

    describe "no dashboards exists" do

      before do
        Freeboard::Dashboard.stubs(:where)
                            .with(key: key)
                            .returns []
      end

      it "should return a blank dashboard" do
        dashboard = Freeboard::Dashboard.pull_from params
        dashboard.is_a?(Freeboard::Dashboard)
        dashboard.id.nil?.must_equal true
      end

      it "should set the key" do
        dashboard = Freeboard::Dashboard.pull_from params
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
          dashboard = Freeboard::Dashboard.pull_from params
          dashboard.must_be_same_as matching_dashboard
        end

      end

      describe "but the dashboard lookup returned something" do

        let(:something) { Object.new }

        before do
          Freeboard::Dashboard.stubs(:lookup_dashboard)
                              .with(params)
                              .returns something
        end

        it "should return that something" do
          dashboard = Freeboard::Dashboard.pull_from params
          dashboard.must_be_same_as something
        end

      end

    end

  end

  describe "lookup dashboard" do

    let(:params) { Object.new }

    it "should return nil" do
      Freeboard::Dashboard.send(:lookup_dashboard, params).nil?.must_equal true
    end

    it "should be an interchangeable method" do
      Interchangeable.methods.select do |method|
        method.target == Freeboard::Dashboard &&
        method.method_name == :lookup_dashboard
      end
    end

    it "should describe what the method is for" do
      Interchangeable.methods.select do |method|
        method.target == Freeboard::Dashboard &&
        method.method_name == :lookup_dashboard &&
        method.description == 'Your own dashboard lookup'
      end

    end

  end

end
