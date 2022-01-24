module Api
    class UsersController < ApplicationController
        before_action :authorized, only: [:auto_login]

        def index
            users = User.all;
            users = users.map {|user| user.attributes.except('id')}
             
            render json:{users: users}
        end

        def show
            user = User.find_by(username: params[:id])
            if user
              render json:{user: user}
            else
              render json:{message: 'User Not Found'}
            end
        end

        def create
            user = User.new(user_params)
            if user.save
                render json: {user: user.attributes.except('id')}
            else
                render json: {message: 'Internal Server Error'}
            end
        end

        def destroy
            user = User.find_by(username: params[:id])
            if user.destroy
              render json:{message: 'User Deleted'}
            else
              render json:{message: 'Failed To Delete User'}
            end
        end

        def update
          user = User.find_by(username: params[:id])
          if user.update({username: params[:username]})
            render json:{message: 'User Updated Successfully'}
          else
            render json:{message: 'Failed to update user'}
          end
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
            params.permit(:username, :password)
        end

    end
end