namespace :user do
  desc "GENERATE SLUGS FOR USERS"
  task gen_slugs: :environment do
    User.find_each(&:save)
  end
end
