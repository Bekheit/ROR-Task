module Api
  class ChatsController < ApplicationController
    $application
    before_action :app_authorized
      
    def index
      if application_decoded_token
        chats = Chat.where(application_id: $application.id)
        chats = chats.map {|chat| chat.attributes.except('id')}
        render json:{chats: chats}
      end
    end

    def show
      if application_decoded_token
        chat = Chat.find_by(number: params[:chat_no], application_id: $application.id)
        if chat
          render json:{chat: chat.attributes.except('id')}
        elsif 
          render json:{message: 'chat not found'}
        end
      end
    end

    def create
      chat = $application.chats.new({number: $application.chats_created + 1})
      if chat.save
          render json:{number: chat.number}
          $application.update({
              chats_count: $application.chats_count + 1,
              chats_created: $application.chats_created + 1
          })
      else
          render json:{message: 'Error'}
      end
    end

    def destroy
      if application_decoded_token
        chat = Chat.find_by(number: params[:chat_no], application_id: $application.id)
        if chat.destroy
          $application.update({chats_count: $application.chats_count - 1})
          render json:{message: 'Chat deleted'}
        elsif 
          render json:{message: 'Failed to delete chat'}
        end
      end
    end

    def update
      if application_decoded_token
        chat = Chat.find_by(number: params[:chat_no], application_id: $application.id)
      end
    end

    def application_decoded_token
        token = params[:app_token]
        token = token.gsub("-", ".")
        begin
            JWT.decode(token, ENV["TokenSecret"], true, algorithm: 'HS256')
          rescue JWT::DecodeError
            nil
        end
    end

    def app_authorized
      if decoded_token
        application_name = application_decoded_token[0]['name']
        $application = Application.find_by(name: application_name)
      end
    end

    
    
  end
end