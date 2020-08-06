# frozen_string_literal: true

class Ckeditor::Picture < Ckeditor::Asset
  def url_content
    rails_representation_url(
      storage_data.variant(resize: "800>").processed,
      only_path: true
    )
  end

  def url_thumb
    rails_representation_url(
      storage_data.variant(resize: "118x100").processed,
      only_path: true
    )
  end
end
