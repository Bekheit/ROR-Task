module Api
    class MessagesController < ApplicationController

        def index
            messages = Message.all
            render json:{messages: messages.except('id')}
        end

        def create
            if application_decoded_token
                application = Application.find_by(name: application_decoded_token[0]['name'])
                chat = Chat.find_by(application_id: application.id, number: params[:chat_no])
                message = chat.messages.new(message_params)
                message.sender_id = 1
                message.number = chat.messages_created + 1
                if message.save
                    render json:{number: message.number}
                    chat.update({
                        messages_count: chat.messages_count + 1,
                        messages_created: chat.messages_created + 1
                    })
                else
                    render json:{message: 'Error'}
                end
            end
        end

        def show
            if application_decoded_token
                application = Application.find_by(name: application_decoded_token[0]['name'])
                chat = Chat.find_by(application_id: application.id, number: params[:chat_no])
                message = Message.find_by({chat_id: chat.id})
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

        private 

        def message_params
            params.permit(:receiver_id, :content)
        end

    end
end