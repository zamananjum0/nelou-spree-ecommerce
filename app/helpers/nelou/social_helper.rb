module Nelou::SocialHelper
  def facebook_app_id
    Rails.configuration.x.social['facebook_app_id']
  end

  def facebook_sharer_path(url)
    params = {
      u: url
    }
    "https://www.facebook.com/sharer/sharer.php?#{params.to_query}"
  end

  def twitter_sharer_path(name, url)
    params = {
      status: "#{name} - #{url}"
    }
    "https://twitter.com/home?#{params.to_query}"
  end
end
