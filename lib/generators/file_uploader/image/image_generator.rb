module FileUploader
  class ImageGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    def create_initializer
      copy_file 'initializers/carrierwave.rb', 'config/initializers/carrierwave.rb'
    end

    def create_uploader
      copy_file 'uploaders/image_uploader.rb', 'app/uploaders/image_uploader.rb'
    end

    def create_model
      copy_file 'models/image.rb', 'app/models/image.rb'
    end

    def create_migration
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