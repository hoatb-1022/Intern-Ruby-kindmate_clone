namespace :api do
  desc "API Routes"
  task routes: :environment do
    API.routes.each do |api|
      method = api.request_method.ljust(10)
      path = api.version ? api.path.gsub(":version", api.version) : api.path.to_s

      puts "#{method} #{path}"
    end
  end
end
