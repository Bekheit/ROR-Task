class Update < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :messages_created, :integer
    add_column :applications, :chats_created, :integer
  end
end
