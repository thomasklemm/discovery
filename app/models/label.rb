class Label < ActiveRecord::Base
  def self.update_labels
    
    # Load a list of all tags (as ActsAsTaggableOn Objects)
    # Tag will be accessible via labels.each do |label| { label["name"] } 
    labels_aato = Repo.tag_counts_on(:labels)
    
    labels = Hash.new
    
    labels_aato.each do |label|
      # Label names transformation from ActsAsTaggable Object to String
      repos = Repo.tagged_with(label[:name], on: :labels).order("watchers DESC")
      
      # How much repos share a certain tag?
      label_stats = Hash.new
      label_stats[:repo_count] = repos.length
      
      # How many total watchers do the repos tagged with a certain label have?
      watcher_count = 0
      repos.each do |repo|
        watcher_count += repo.watchers
      end
      label_stats[:watcher_count] = watcher_count
      
      # Which are the top repos (sorted by watchers) for a certain tag
      label_stats[:top_repos] = String.new
      
      repos.each do |repo|
        label_stats[:top_repos] << repo.ident + " "
      end 
      
      labels[label[:name]] = label_stats
    end
    
    
    # Reset repo_count of all labels to 0 in order to put unused categories on hold
    labels_all = Label.all
    
    labels_all.each do |label|
      label.repo_count = 0
      
      # Make sure that there is no nil value for the description (otherwise list.js will have difficulties)
      if label.description.nil?
        label.description = "---"
      end
      
      label.save
    end
    
    
    # Set current stats
    labels.each do |label, label_stats|
      l = Label.find_or_initialize_by_name(label)
      l.repo_count = label_stats[:repo_count]
      l.watcher_count = label_stats[:watcher_count]
      l.top_repos = label_stats[:top_repos]
      l.save
    end
    
  end
end
