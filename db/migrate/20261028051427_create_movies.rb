class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string "title"
      t.integer "tear_released"
      t.string "rated"
      t.integer "studio_id"
      t.timestamps
    end
  end
end
