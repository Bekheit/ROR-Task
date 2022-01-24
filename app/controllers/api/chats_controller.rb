module Api
  class ChatsController < ApplicationController
      
    def index
      if application_decoded_token
        application = Application.find_by(name: application_decoded_token[0]['name'])
        chats = Chat.find_by(application_id: application.id)
        chats = chats.map {|chat| chat.attributes.except('id')}
        render json:{chats: chats}
      end
    end

    def show
      if application_decoded_token
        application = Application.find_by(name: application_decoded_token[0]['name'])
        chat = chat.find_by(number: params[:chat_no], application_id: application.id)
        if chat
          render json:{chat: chat.attributes.except('id')}
        elsif 
          render json:{message: 'chat not found'}
        end
      end
    end

    def create
        if application_decoded_token
            application = Application.find_by(name: application_decoded_token[0]['name'])
            chat = application.chats.new({number: application.chats_created + 1})
            if chat.save
                render json:{number: chat.number}
                application.update({
                    chats_count: application.chats_count + 1,
                    chats_created: application.chats_created + 1
                })
            else
                render json:{message: 'Error'}
            end
        end
    end

    def destroy
      if application_decoded_token
        application = Application.find_by(name: application_decoded_token[0]['name'])
        chat = chat.find_by(number: params[:chat_no], application_id: application.id)
        if chat.destroy
          application.update({chats_count: application.chats_count - 1})
          render json:{message: 'Chat deleted'}
        elsif 
          render json:{message: 'Failed to delete chat'}
        end
      end
    end

    def update
      if application_decoded_token
        application = Application.find_by(name: application_decoded_token[0]['name'])
        chat = chat.find_by(number: params[:chat_no], application_id: application.id)
        
      end
    end

    def application_decoded_token
        token = params[:token]
        token = token.gsub("-", ".")
        begin
            JWT.decode(token, 'yourSecret', true, algorithm: 'HS256')
          rescue JWT::DecodeError
            nil
        end
    end
  end
end