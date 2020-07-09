module ApplicationHelper
  def full_title page_title
    base_title = t "global.app_title"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def get_locale
    I18n.locale
  end
end
