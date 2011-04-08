module Haml2Erb
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), '..', '..', 'tasks/haml2erb.rake')
    end
  end
end