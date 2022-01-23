module Api
        class ChatsController < ApplicationController
            
            def index
                chats = Chat.all
                render json:{chats: chats.except('id')}
            end

            def create
                if application_decoded_token
                    application = Application.find_by(name: application_decoded_token[0]['name'])
                    p application
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