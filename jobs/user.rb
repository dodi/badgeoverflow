require 'badgeoverflow/core'

service = StackExchangeService.new
user_id = BadgeOverflowConfig.user_id
avatar_size = 230

SCHEDULER.every '1h', :first_in => 0 do |job|
  service.fetch 'users', ids: user_id do |users|
    user = users.first

    profile_image = user['profile_image']
    if profile_image.include? 'gravatar.com'
      profile_image << "&size=#{avatar_size}"
    end

    badge_counts = user['badge_counts'].map { |r,c| { rank: r, count: c } }
    badge_counts.reverse!

    send_event 'user', {
      name: user['display_name'],
      link: user['link'],
      reputation: user['reputation'].with_suffix,
      badge_counts: badge_counts,
      image: profile_image,
      width: avatar_size
    }
  end
end
