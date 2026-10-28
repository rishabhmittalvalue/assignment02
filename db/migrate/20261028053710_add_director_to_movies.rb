class AddDirectorToMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :movies, :director, :string
  end
end
