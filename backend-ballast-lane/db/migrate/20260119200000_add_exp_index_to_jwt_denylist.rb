class AddExpIndexToJwtDenylist < ActiveRecord::Migration[7.2]
  def change
    add_index :jwt_denylist, :exp, name: "index_jwt_denylist_on_exp"
  end
end
