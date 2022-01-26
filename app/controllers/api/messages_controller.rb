module Api
  class MessagesController < ApplicationController
    before_action :app_authorized

    def index
      application = Application.find_by(name: application_decoded_token[0]['name'])
      chat = Chat.find_by(number: params[:chat_no], application_id: application.id)
      messages = Message.where({chat_id: chat.id})
      messages = messages.map {|message| message.attributes.except('id', 'sender_id', 'receiver_id', 'chat_id')}
      render json:{messages: messages}
    end

    def contain
      application = Application.find_by(name: application_decoded_token[0]['name'])
      chat = Chat.find_by(number: params[:chat_no], application_id: application.id)
      messages = Message.find_by({chat_id: chat.id})
      messages = messages.where("content like ?", "%#{params[:message]}%")
      messages = messages.map {|message| message.attributes.except('id', 'sender_id', 'receiver_id', 'chat_id')}
      render json:{messages: messages}
    end

    def show
      application = Application.find_by(name: application_decoded_token[0]['name'])
      chat = Chat.find_by(number: params[:chat_no], application_id: application.id)
      message = Message.find_by({number: params[:message_no], chat_id: chat.id})
      if message
        render json:{content: message.content}
      else
        render json:{message: 'Message not found'}
      end
    end

    def create
      application = Application.find_by(name: application_decoded_token[0]['name'])
      chat = Chat.find_by(number: params[:chat_no], application_id: application.id)
      message = chat.messages.new(message_params)
      message.sender_id = params[:user].id
      message.number = chat.messages_created + 1
      if message.save
        chat.update({
          messages_count: chat.messages_count + 1,
          messages_created: chat.messages_created + 1
        })
        render json:{number: message.number}
      else
          render json:{message: 'Error'}
      end
    end

    def destroy
      application = Application.find_by(name: application_decoded_token[0]['name'])
      chat = Chat.find_by(number: params[:chat_no], application_id: application.id)
      message = Message.find_by({number: params[:message_no], chat_id: chat.id})
      if message.destroy
        chat.update({messages_count: chat.messages_count - 1})
        render json:{message: 'Message deleted'}
      elsif 
        render json:{message: 'Failed to delete message'}
      end
    end

    def update
      application = Application.find_by(name: application_decoded_token[0]['name'])
      chat = Chat.find_by(number: params[:chat_no], application_id: application.id)
      message = Message.find_by({number: params[:message_no], chat_id: chat.id})
      if message.update({content: params[:content]})
        render json:{message: 'Message updated Successfully'}
      elsif 
        render json:{message: 'Failed to update message'}
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
        application = Application.find_by(name: application_name)
      end
    end

    private 

    def message_params
      params.permit(:receiver_id, :content)
    end

  end
end