require 'test_helper'

class SessionTest < ActiveSupport::TestCase

  
  test "get access token with refresh token" do
    refresh_token = ENV['refresh_token']
    user = User.create!(:name => 'admin', :refresh_token => refresh_token)
    Session.get_new_token(user)    
    assert_not_nil User.context_user.access_token 
  end
  
  
  test "post a feed item" do
    user = User.new :access_token => ENV['access_token'],
                    :instance_url => "https://prerelna1.pre.salesforce.com"
    uri = "/chatter/feeds/record/#{Qa::GROUP_ID}/feed-items"
    text = "a test"
    resp = Session.do_post(user, uri, text)
    puts resp['id']
    uri = "/chatter/feed-items/#{resp['id']}/comments"
    resp = Session.do_get(user, uri)
    puts resp.comments
  end
  
  # issues
  # 1. have to learn SOQL to get a collection - makes the easy things hard - every other api 
  #    its simply GET /resource name.  the /accounts URL which should return a collection doesn't.
  # 2. keys are case sensitive in the response but not in the query 
  # 3. the labels in the UI and the keys in the API are different: "hertz" in the UI label
  #    and "hertz__c" in the API.  Both object and attribute names differ for custom objects 
  #    and custom fields between the UI and the API.
  # 4. results are not localized
  # 
  test "get list of records" do
    user = User.new :access_token => ENV['access_token'],
                    :instance_url => "https://na7.salesforce.com"
    response = Session.do_get(user, "/query/?q=SELECT+name+,+id+,+hertz__c+,+description__c+,+voltage__c+,+amps__c+from+Engine__c")
    puts response['records'].inspect
    puts response['records'][0]['Name']
    puts response['records'][0]['Id']
    puts response['records'][0]['Hertz__c']
    puts response['records'][0]['Amps__c']
    puts response['records'][0]['Voltage__c']
    puts response['records'][0]['Description__c']
  end
  
  
end