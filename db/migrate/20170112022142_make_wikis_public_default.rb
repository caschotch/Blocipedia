class MakeWikisPublicDefault < ActiveRecord::Migration
  def change
    change_column :wikis, :private, :boolean, default: false
  end
end
