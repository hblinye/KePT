class AddSkeyToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :skey, :string
  end
end
