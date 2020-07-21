module DonationsHelper
  def donation_payment_type_icon donation
    image_tag "svg/#{donation.payment_type}.svg"
  end

  def donation_payment_short_info donation
    payment_type_str = t "donations.new.#{donation.payment_type}"
    time_ago = t "global.time_ago", time: time_ago_in_words(donation.created_at)
    "#{donation.payment_code} - #{payment_type_str} - #{time_ago}"
  end
end
