class LabelsController < ApplicationController
  # GET /labels
  # GET /labels.json
  # OVERVIEW OVER ALL LABELS
  def index
    # Update Label indexes
    Label.update_labels
    
    # Initial ordering, user can search and sort via list.js
    @labels = Label.where("repo_count > 0").order("watcher_count DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labels }
    end
  end

  # ADD AND DELETE LABELS
  # POST /labels
  def create
    repo = Repo.find(params[:repo_id])

    label_name = params[:label_name].downcase
    
    respond_to do |format|
      format.html {        
        # Which ActsAsTaggableOn Context do we want to tag?
        if params["add_label"]
          repo.label_list << label_name
          repo.save
          redirect_to :back, notice: "Tagging action succeeded."
        elsif params["remove_label"]
          repo.label_list << label_name
          repo.label_list.delete(label_name)
          repo.save
          redirect_to :back, notice: "Tagging action succeeded."
        elsif params["add_framework"]
          repo.framework_list << label_name
          repo.save
          redirect_to :back, notice: "Tagging action succeeded."          
        elsif params["remove_framework"]
          repo.framework_list << label_name
          repo.framework_list.delete(label_name)
          repo.save
          redirect_to :back, notice: "Tagging action succeeded."          
        elsif params["add_language"]
          repo.language_list << label_name
          repo.save
          redirect_to :back, notice: "Tagging action succeeded."          
        elsif params["remove_language"]
          repo.language_list << label_name
          repo.language_list.delete(label_name)
          repo.save
          redirect_to :back, notice: "Tagging action succeeded."          
        else
          #no particular action wish was send along
          redirect_to :back, notice: "Tagging action did not succeed. Please mail my creators that I did not receive instruction where to put this tag or label." 
        end 
      }
    end
  end 
  
  # POST /do/addlabel
  def addlabel
    repo = Repo.find(params[:repo_id])
    label = params[:label].downcase.strip
    action = params[:do]
    
    repo.label_list << label
    
    if action == "removed"
      repo.label_list.delete(label)
    end
    
    repo.save
    
    Label.update_labels
        
    respond_to do |format|
      format.html { redirect_to repo, notice: "Label '#{label}' successfully #{action}." }
    end
  end
  
  # GET /labels/1
  # GET /labels/1.json
  def show
    @label = Label.find_by_id(params[:id])
    if @label.nil?
      @label = Label.find_by_name(params[:id])
    end

    @repos = Repo.tagged_with(@label.name, on: :labels).order("watchers DESC")
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @label }
    end
  end

  # ADD A DESCRIPTION TO A LABEL
  # POST 'do/addlabeldesc'
  def addlabeldesc
    label = Label.find(params[:label][:id])
    label.description = params[:label][:description].strip
    label.save
    
    respond_to do |format|
      format.html { redirect_to label, notice: "The description for this label has been successfully updated." }
    end
    
  end



  # GET /labels/new
  # GET /labels/new.json
  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @label }
    end
  end

  # GET /labels/1/edit
  def edit
    @label = Label.find(params[:id])
  end
  
  
  # PUT /labels/1
  # PUT /labels/1.json
  def update
    @label = Label.find(params[:id])

    respond_to do |format|
      if @label.update_attributes(params[:label])
        format.html { redirect_to @label, notice: 'Label was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1
  # DELETE /labels/1.json
  def destroy
    @label = Label.find(params[:id])
    @label.destroy

    respond_to do |format|
      format.html { redirect_to labels_url }
      format.json { head :ok }
    end
  end
  
end
