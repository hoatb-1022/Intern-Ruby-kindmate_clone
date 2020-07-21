module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar_size}
    user_email = user ? user.email.downcase : "unknown@kindmate.com"
    gravatar_id = Digest::MD5.hexdigest user_email
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    image_tag gravatar_url, class: "gravatar"
  end

  def user_change_status_link user
    link_text = t "users.do_active"
    link_status = 0

    if user.is_blocked?
      link_text = t "users.do_block"
      link_status = 1
    end

    link_to(
      link_text,
      admin_user_path(user, status: link_status),
      method: "patch",
      class: "dropdown-item"
    )
  end

  def user_status_badge user
    if user.is_blocked?
      {text: t("users.blocked"), variant: "danger"}
    else
      {text: t("users.active"), variant: "success"}
    end
  end
end
