namespace :campaign do
  desc "GENERATE SLUGS FOR CAMPAIGNS"
  task gen_slugs: :environment do
    Campaign.find_each(&:save)
  end
end
