module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar_size}
    user_email = user ? user.email.downcase : "unknown@kindmate.com"
    gravatar_id = Digest::MD5.hexdigest user_email
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    image_tag gravatar_url, class: "gravatar"
  end
end
