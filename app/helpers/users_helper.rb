module UsersHelper
  def gravatar_for user, options = { size: Settings.helpers.users.gravatar_for }
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = Settings.helpers.users.gravatar_url + "#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
