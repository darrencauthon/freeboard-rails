require_relative '../../../minitest_helper'

describe Freeboard::Dashboard do

  before { Freeboard::Dashboard.delete_all }

  it "should let me do something" do
    Freeboard::Dashboard.create
    Freeboard::Dashboard.count.must_equal 1
  end

  describe "credentials" do

    let(:dashboard) { Freeboard::Dashboard.create }

    it "should let credentials be an empty hash" do
      dashboard.credentials.count.must_equal 0
    end

    it "should let me save things in the hash" do
      username, password = random_string, random_string
      dashboard.credentials[:username] = username
      dashboard.credentials[:password] = password
      dashboard.save!

      result = Freeboard::Dashboard.find dashboard.id

      result.credentials[:username].must_equal username
      result.credentials[:password].must_equal password
    end

  end

end
