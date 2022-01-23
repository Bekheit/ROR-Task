class Chat < ApplicationRecord
    after_initialize :init
    has_one :application
    has_many :messages

    def init
        self.messages_count ||= 0
        self.messages_created ||= 0
    end
end
