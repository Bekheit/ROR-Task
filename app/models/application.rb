class Application < ApplicationRecord
    after_initialize :init
    has_many :chats

    validates :name, :presence => true, :uniqueness => true

    def init
        self.chats_count ||= 0
        self.chats_created ||= 0
    end
end
