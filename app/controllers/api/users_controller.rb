module Api
    class UsersController < ApplicationController
        before_action :authorized, only: [:auto_login]

        def index
            users = User.all;
            users = users.map {|user| user.attributes.except('id')}
             
            render json:{users: users}
        end

        def show
            user = User.find_by(username: params[:username])
            if user
              render json:{user: user}
            else
              render json:{message: 'User Not Found'}
            end
        end

        def create
          if username_exist(params[:username])
            return render json:{message: 'Username is already exist'}
          end
          user = User.new(user_params)
          if user.save
              render json: {user: user.attributes.except('id')}
          else
              render json: {message: user.errors}
          end
        end

        def destroy
          if !username_exist(params[:username])
            return render json:{message: 'Username does not exist'}
          end
            user = User.find_by(username: params[:username])
            if user.destroy
              render json:{message: 'User Deleted'}
            else
              render json:{message: user.errors}
            end
        end

        def update
          
          if !username_exist(params[:username])
            return render json:{message: 'Username does not exist'}
          elsif username_exist(params[:new_username])
            return render json:{message: 'Username is already exist'}
          end
          user = User.find_by(username: params[:username])
          if user.update({username: params[:new_username]})
            render json:{message: 'User Updated Successfully'}
          else
            render json:{message: user.errors}
          end
        end

        def login
            user = User.find_by(username: params[:username])

            if user && user.authenticate(params[:password])
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

        def username_exist(username)
          user = User.find_by(username: username)
        end

    end
end