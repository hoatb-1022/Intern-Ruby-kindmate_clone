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

  def link_to_add_tag form, association
    new_tag = form.object.send(association).klass.new
    id = new_tag.object_id
    fields = form.fields_for(association, new_tag, child_index: id) do |tag_builder|
      render "tags/#{association.to_s.singularize}", t: tag_builder
    end
    link_to(
      "#",
      class: "btn btn-sm btn-default common-icon-btn btn-add-tags",
      data: {id: id, fields: fields.gsub("\n", "")}
    ) do
      sanitize "<i class='fas fa-plus'></i>"
    end
  end
end
