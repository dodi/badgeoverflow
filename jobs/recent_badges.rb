require 'net/http'
require 'json'

# Steph Sharp: 1367622 
# Adam Sharp: 1164143
# David Underwood: 131066
# Daniel Beauchamp: 208314
# Edward Ocampo-Gooding: 95705
# Jeff Atwood: 1
user_id = 1367622

# Get timeline for user - /users/{ids}/timeline 
SCHEDULER.every '1h', :first_in => 0 do |job|
  stack_exchange = Net::HTTP.new('api.stackexchange.com')
  recent_badges = Hash.new({ value: 0 });
  number_of_badges = 5
  page_number = 1
  
  loop do
    user_timeline_response = JSON.parse(stack_exchange.get("/2.1/users/#{user_id}/timeline?page=#{page_number}&pagesize=100&site=stackoverflow").body)

    # Get badges in timeline
    user_timeline_response['items'].each do |item|
      if item['timeline_type'] == "badge" && recent_badges.length < number_of_badges
        recent_badges[item['detail']] = { rank: item['badge_id'], label: item['detail'] }
      end
    end
  
    page_number += 1
    backoff = user_timeline_response['backoff']
    
    if backoff
      sleep backoff
    end

    # break loop unless there are more pages to search and not enough badges have been found
    break unless (user_timeline_response['has_more'] && recent_badges.length < number_of_badges)
  end  

  # Check if user has no badges
  if recent_badges.empty?
    recent_badges["No Badges"] = { rank: "", label: "No Badges" }
  end

  # Display recently awarded badges
  send_event('recent_badges', { items: recent_badges.values })

end
