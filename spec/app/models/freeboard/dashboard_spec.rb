require_relative '../../../minitest_helper'

describe Freeboard::Dashboard do
  it "should let me do something" do
    Freeboard::Dashboard.delete_all
    Freeboard::Dashboard.create
    Freeboard::Dashboard.count.must_equal 1
  end
end
