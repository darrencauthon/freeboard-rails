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
      Freeboard::Dashboard.stubs(:pull_from).with(params).returns dashboard
      controller.index
      controller.instance_eval { @dashboard }.must_be_same_as dashboard
    end
  end

  describe "get_board" do
    it "should return the dashboard data as json" do
      dashboard = Struct.new(:data).new Object.new
      Freeboard::Dashboard.stubs(:pull_from).with(params).returns dashboard
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
      Freeboard::Dashboard.stubs(:pull_from).with(params).returns dashboard

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

end
