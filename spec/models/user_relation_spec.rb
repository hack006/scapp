require 'spec_helper'

describe UserRelation do
  before do
    @user1 = FactoryGirl.create(:coach, name: 'user1', email: 'user1@example.com')
    @user2 = FactoryGirl.create(:player, name: 'user2', email: 'user2@example.com')
  end


  describe 'in_relation?' do

    it "should confirm relation if successfully connected" do
      # create confirmed connection
      ur = UserRelation.new(from: @user1, to: @user2, relation: 'coach', from_user_status: 'accepted',
                           to_user_status: 'accepted')
      ur.save
      # test
      UserRelation.in_relation?(@user1, @user2, :coach).should be_true
    end

    it "should reject relation if one or both sides are uncorfimed" do
      # create unconfirmed connection
      ur = UserRelation.new(from: @user1, to: @user2, relation: 'coach', from_user_status: 'accepted',
                           to_user_status: 'new')
      ur.save
      # test
      UserRelation.in_relation?(@user1, @user2, :coach).should be_false
    end

    it "should reject relation if no connection exists at all" do
      # test
      UserRelation.in_relation?(@user1, @user2, :coach).should be_false
    end

  end

  describe 'add_relation' do
    it "should confirm relation if created with both sides accepted" do
      UserRelation.add_relation @user1, @user2, 'friend', 'accepted', 'accepted'
      # test
      UserRelation.in_relation?(@user1, @user2, 'friend').should be_true
    end

    it "should create not confirmed relation if relation states not provided" do
      UserRelation.add_relation @user1, @user2, 'friend'
      # test
      UserRelation.in_relation?(@user1, @user2, 'friend').should be_false
    end
  end

  describe 'get_my_relations_with_statuses' do
    it "should return my refused connections if some exists" do
      # create refused connection
      UserRelation.add_relation @user2, @user1, 'friend', 'accepted', 'refused'
      # test
      @user1.get_my_relations_with_statuses('refused').count().should eq 1
    end

    it "should return no my refused connections if only accepted and new exists" do
      UserRelation.add_relation @user2, @user1, 'friend', 'accepted', 'accepted'
      UserRelation.add_relation @user1, @user2, 'coach', 'accepted', 'new'
      # test
      @user1.get_my_relations_with_statuses('refused').count().should eq 0
      @user2.get_my_relations_with_statuses('refused').count().should eq 0
    end
  end

end
