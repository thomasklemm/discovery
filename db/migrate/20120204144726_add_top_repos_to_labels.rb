class AddTopReposToLabels < ActiveRecord::Migration
  def change
    add_column :labels, :top_repos, :string
  end
end
