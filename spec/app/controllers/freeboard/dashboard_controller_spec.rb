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

  describe "get_board" do
    it "should return the dashboard data as json" do
      dashboard = Struct.new(:data).new Object.new
      controller.stubs(:dashboard).returns dashboard
      controller.expects(:render).with(json: { data: dashboard.data })
      controller.get_board
    end
  end

  describe "save_board" do

    let(:new_data)  { Object.new }
    let(:dashboard) { Struct.new(:data).new Object.new }

    let(:jsonified_data) { Object.new }

    before do
      params[:data] = new_data
      controller.stubs(:dashboard).returns dashboard

      JSON.stubs(:parse).with(new_data).returns jsonified_data

      dashboard.stubs(:save)
      controller.stubs(:render)
    end

    it "should save the jsonified data" do
      json = jsonified_data
      dashboard.expects(:save).with do
        dashboard.data.must_be_same_as json
      end
      controller.save_board
    end

    it "should render the dashboard data as json" do
      controller.expects(:render).with( { json: { data: jsonified_data } } )
      controller.save_board
    end

  end

  describe "dashboard" do

    let(:key) { Object.new }

    before do
      params[:key] = key
      controller.stubs(:lookup_dashboard).returns nil
    end

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

      describe "but the dashboard lookup returned nothing" do

        it "should return the dashboard" do
          dashboard = controller.send(:dashboard)
          dashboard.must_be_same_as matching_dashboard
        end

      end

      describe "but the dashboard lookup returned something" do

        let(:something) { Object.new }

        before do
          controller.stubs(:lookup_dashboard).returns something
        end

        it "should return that something" do
          dashboard = controller.send(:dashboard)
          dashboard.must_be_same_as something
        end

      end

    end

  end

  describe "lookup dashboard" do
    it "should return nil" do
      controller.send(:lookup_dashboard).nil?.must_equal true
    end

    it "should be an interchangeable method" do
      Interchangeable.methods.select do |method|
        method.target == Freeboard::DashboardController &&
        method.method_name == :lookup_dashboard
      end
    end

    it "should describe what the method is for" do
      Interchangeable.methods.select do |method|
        method.target == Freeboard::DashboardController &&
        method.method_name == :lookup_dashboard &&
        method.description == 'Your own dashboard lookup'
      end
    end
  end

  describe "conditional http authentication" do

    let(:dashboard) { Object.new }

    before { controller.stubs(:dashboard).returns dashboard }

    describe "the dashboard has http authentication" do

      let(:username) { random_string }
      let(:password) { random_string }

      before { dashboard.stubs(:requires_authentication?).returns true }

      it "should make the request authenticate with basic http authentication" do
        controller.expects(:authenticate_or_request_with_http_basic).with('auth')
        controller.send :authenticate
      end

      it "should check the username and password" do
        dashboard.stubs(:credentials).returns( { username: username, password: password } )
        controller.stubs(:username).returns username
        controller.stubs(:password).returns password
        def controller.authenticate_or_request_with_http_basic _, &block
          block.call(username, password).must_equal true
          block.call(random_string, random_string).must_equal false
          block.call(random_string, password).must_equal false
          block.call(username, random_string).must_equal false
        end
        controller.send :authenticate
      end

    end

    describe "the dashboard has NO authentication" do

      before { dashboard.stubs(:requires_authentication?).returns false }

      it "should NOT make the request authenticate with basic http authentication" do
        controller.expects(:authenticate_or_request_with_http_basic).never
        controller.send :authenticate
      end

    end

  end

end
