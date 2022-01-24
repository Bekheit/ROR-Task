class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number
      t.integer :messages_count
      t.integer :application_id
      t.integer :messages_created

      t.timestamps
    end
  end
end
