require 'spec_helper'

describe UriName, :type => :model do
  it "should have a valid factory" do
    expect(build(:uri_name_for_user)).to be_valid
    expect(build(:uri_name_for_group)).to be_valid
  end

  describe "#resource" do
    it "should not be valid without a resource" do
      expect(build(:uri_name)).to_not be_valid
    end

    it "should be able to be user" do
      expect(create(:uri_name_for_user).resource).to be_a(User)
    end

    it "should be able to be a group" do
      expect(create(:uri_name_for_group).resource).to be_a(UserGroup)
    end
  end
end
