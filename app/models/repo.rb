class Repo < ActiveRecord::Base
  validates :owner, :name, presence: true
  validates :ident, uniqueness: true
  
  acts_as_taggable_on :labels, :frameworks, :languages
  
  protected
  
   def self.init_repo(repo_id)
    repo = Repo.find(repo_id)
    github_api_url = "https://api.github.com/repos/"
    
    github = JSON.parse(Curl::Easy.perform(github_api_url + repo.owner + "/" + repo.name).body_str)
    if github["message"] == "Not Found"
      repo.destroy
      return false
    else
      %w{name description watchers forks html_url homepage}.each do |field|
          repo[field] = github[field]
      end
      repo["owner"] = github["owner"]["login"]
      repo["last_updated"] = github["updated_at"]
      repo["ident"] = github["owner"]["login"] + "/" + github["name"]
      # Repo speichern
      repo.save
      return true
    end
  end
  
  def self.update_repos
    repos = Repo.all
    github_api_url = "https://api.github.com/repos/"
  
    repos.each do |repo|
      github = JSON.parse(Curl::Easy.perform(github_api_url + repo.owner + "/" + repo.name).body_str)
      %w{name description watchers forks html_url homepage}.each do |field|
        repo[field] = github[field]
      end
      repo["owner"] = github["owner"]["login"]
      repo["last_updated"] = github["updated_at"]
      # Repo speichern
      repo.save
    end
    
    puts "Repo.update_repos successfully finished."
  end
end
