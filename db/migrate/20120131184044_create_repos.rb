class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :ident
      t.string :name
      t.string :owner
      t.text :description
      t.integer :watchers
      t.integer :forks
      t.string :html_url
      t.string :homepage
      t.datetime :last_updated
      t.text :community_text

      t.timestamps
    end
  end
end
