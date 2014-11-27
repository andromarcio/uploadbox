module Uploadbox
  class ImageGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    def create_initializers
      copy_file 'initializers/uploadbox.rb', 'config/initializers/uploadbox.rb'
    end

    def add_route
      route "mount Uploadbox::Engine => '/uploadbox', as: :uploadbox"
    end

    def copy_migration
      migration_template 'migrate/create_images.rb', 'db/migrate/create_images.rb'
    end

    private
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime('%Y%m%d%H%M%S')
        else
          '%.3d' % (current_migration_number(dirname) + 1)
        end
      end
  end
end
