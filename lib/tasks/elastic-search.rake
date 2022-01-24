namespace :elastic_search do
    desc 'Index models to elasticsearch'
    task :index_models, [:models] => :environment do |_, args|
      # eager load first so that models are available for next step
        Rails.application.eager_load!
        
        # include all models inside the app/models folder
        default_models = ['Message']
    
        argument_models = args[:models]&.split(',')&.map(&:strip)
        models = argument_models || default_models
    
        model_classes = models.map { |model| model.underscore.camelize.constantize }
        
        model_classes.each do |model|
            model.import force: true
        end
    end
  end