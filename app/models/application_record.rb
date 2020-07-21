class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :filter_by_string_attr, (lambda do |attr, value|
    return unless attr.present? && value.present?

    where arel_table[attr].lower.matches "%#{value.downcase}%"
  end)

  scope :filter_by_number_attr, (lambda do |attr, value|
    return unless attr.present? && value.present?

    where arel_table[attr].eq value
  end)
end
