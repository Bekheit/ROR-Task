module Api
    class ApplicationsController < ApplicationController

        def index
            applications = Application.all
            applications = applications.map {|application| application.attributes.except('id')}
            render json:{applications: applications}
        end

        def show
            application = Application.find_by(name: params[:id])
           if application
            render json:{application: application.attributes.except('id')}
           elsif 
             render json:{message: 'Application not found'}
           end
        end

        def create
            application = Application.new(application_params)
            application.token = encode_token({name: application.name})
            if application.save
                render json: {application: application}
            else
                render json: {message: 'Internal Server Error'}
            end
        end

        def destroy
          application = Application.find_by(name: params[:id])
          if application.destroy
            render json:{message: 'Application deleted'}
          elsif 
            render json:{message: 'Failed to delete application'}
          end
        end

        def update
          application = Application.find_by(name: params[:id])
          if application.update({name: params[:name]})
            render json:{message: 'Application Updated Successfully'}
          elsif 
            render json:{message: 'Failed to update application'}
          end
        end

        private

        def application_params
            params.permit(:name)
        end
    end
end