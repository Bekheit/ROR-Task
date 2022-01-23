module Api
    class UsersController < ApplicationController
        before_action :authorized, only: [:auto_login]

        def index
            users = User.all;
            render json:{data: users}
        end

        def show
            user = User.find(params[:id])
            render json:{data: user}
        end

        def create
            user = User.new(user_params)
            if user.save
                render json: {data: user}
            else
                render json: {data: '500'}
            end
        end

        def destroy
            user = User.find(params[:id])
            user.destroy
        end

        def hamada
            render json: {data:'hamda'}
        end

        def login
            user = User.find_by(name: params[:name])

            if user && user.authenticate(params[:password])
                Current.user = user
                # p Current.user
                token = encode_token({user_id: user.id})
                render json: {user: user.attributes.except('id'), token: token}
            else
                render json: {error: "Invalid username or password"}
            end
        end


        def auto_login
            render json: user
        end


        private

        def user_params
            params.permit(:name, :password, :email)
        end

    end
end