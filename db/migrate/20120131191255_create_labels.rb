class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.integer :repo_count
      t.integer :watcher_count
      t.text :description

      t.timestamps
    end
  end
end
