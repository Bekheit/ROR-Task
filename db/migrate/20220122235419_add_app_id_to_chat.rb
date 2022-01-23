class AddAppIdToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :application_id, :integer
  end
end
