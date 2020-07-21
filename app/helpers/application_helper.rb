module ApplicationHelper
  def full_title page_title, is_admin = false
    base_title = is_admin ? t("global.app_admin_title") : t("global.app_title")
    page_title.blank? ? base_title : [page_title, base_title].join(" | ")
  end

  def get_locale
    I18n.locale
  end

  def percentage_no_precision percent
    number_to_percentage percent, precision: 0
  end

  def currency_no_precision number
    number_to_currency number, precision: 0
  end
end
