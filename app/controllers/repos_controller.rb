class ReposController < ApplicationController
  # GET /repos
  # GET /repos.json
  def index
    # Fetch all repos ordered by watchers DESC, reordering through list.js
    @repos = Repo.order("watchers DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @repos }
    end
  end

  # GET /repos/1
  # GET /repos/1.json
  def show
    if params[:id]
      @repo = Repo.find_by_id(params[:id])
      ident = "with ID " + params[:id].to_s
    elsif (params[:owner] and params[:name])
      @repo = Repo.find_by_owner_and_name(params[:owner].strip, params[:name].strip)
      ident = params[:owner].strip + "/" + params[:name].strip
    end
    
    unless @repo.nil?
      @alternatives = @repo.find_related_labels
    end

    respond_to do |format|
      unless @repo.nil? 
        # Repo and Alternatives found
        format.html # show.html.erb
        format.json { render json: @repo }
      else
        # Repo could not be found
        redirect_to :root, notice: "Repo '#{ident}' could not be found."
      end
    end
  end

  # POST /repos
  # POST /repos.json
  # ADD A NEW REPOSITORY VIA BOOKMARKLET OR FORM FIELDS
  def create
    # Create an empty repo in memory
    repo = Repo.new
    
    # Var. 1) Github Repo posted to "/addrepo?url="
    if params[:url]
      url = params[:url]
      # Strip url of leading or trailing whitespace
      # Gsub part of url that is not nescessary
      ident = url.gsub("https://github.com/", "").strip
    
      # Split repo ident
      repo.owner = ident.split("/")[0]
      repo.name = ident.split("/")[1]
      repo.ident = ident
    end
  
    # Var. 2) Github Repo is being added by posting to "/repo" through form
    if params[:repo]
      # Remove leading and trialing whitespace
      repo.owner = params[:repo][:owner].strip
      repo.name = params[:repo][:name].strip
      repo.ident = repo.owner + "/" + repo.name
    end
    
    respond_to do |format|
      if Repo.find_by_ident(repo.ident).nil?
        # Repo is not yet listed
        if repo.save # Check if validations pass
          # Validations passed
          if Repo.init_repo(repo.id)
            # Repo could be found on Github
            format.html { redirect_to repo, notice: "Success! You added '#{repo.owner}/#{repo.name}' successfully. Thanks for helping to improve this site! You might tag this repo!!!" }
          else
            # Repo could not be found on Github and was deleted
            format.html { redirect_to root_url, notice: "Sorry. I could not find '#{repo.owner}/#{repo.name} on github. Spelled everything correctly?"}
          end
            # Repo validation fails while performing initialization
            format.html { redirect_to root_url, notice: "Repo validation failed. Please mail our team with details how you managed to get this error."}
        else
          # Validation failed
          format.html { redirect_to root_url, notice: "Sorry, I could not recognize a repo owner and name in there. My bad." }
        end
        
      else
        # Repo already listed 
        repo = Repo.find_by_ident(repo.ident) 
        format.html { redirect_to repo, notice: "Double success! '#{repo.owner}/#{repo.name}' is listed already. Checkout the tags below and refine them to do some good for your fellow human programmers. Thanks!"}
      end
    end
  end
  
=begin
  # UNUSED METHODS GENERATED VIA SCAFFOLDING
  
  # GET /repos/new
  # GET /repos/new.json
  def new
    @repo = Repo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repo }
    end
  end

  # GET /repos/1/edit
  def edit
    @repo = Repo.find(params[:id])
  end

  # PUT /repos/1
  # PUT /repos/1.json
  def update
    @repo = Repo.find(params[:id])

    respond_to do |format|
      if @repo.update_attributes(params[:repo])
        format.html { redirect_to @repo, notice: 'Repo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repos/1
  # DELETE /repos/1.json
  def destroy
    @repo = Repo.find(params[:id])
    @repo.destroy

    respond_to do |format|
      format.html { redirect_to repos_url }
      format.json { head :ok }
    end
  end
=end

end
