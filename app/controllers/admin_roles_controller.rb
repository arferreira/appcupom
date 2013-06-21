class AdminRolesController < ApplicationController
  before_filter :authenticate#, :only => [:edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  
  # GET /admin_roles
  # GET /admin_roles.json
  def index
    @admin_roles = AdminRole.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_roles }
    end
  end

  # GET /admin_roles/1
  # GET /admin_roles/1.json
  def show
    @admin_role = AdminRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_role }
    end
  end

  # GET /admin_roles/new
  # GET /admin_roles/new.json
  def new
    @admin_role = AdminRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_role }
    end
  end

  # GET /admin_roles/1/edit
  def edit
    @admin_role = AdminRole.find(params[:id])
  end

  # POST /admin_roles
  # POST /admin_roles.json
  def create
    @admin_role = AdminRole.new(params[:admin_role])

    respond_to do |format|
      if @admin_role.save
        format.html { redirect_to @admin_role, notice: 'Admin role was successfully created.' }
        format.json { render json: @admin_role, status: :created, location: @admin_role }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin_roles/1
  # PUT /admin_roles/1.json
  def update
    @admin_role = AdminRole.find(params[:id])

    respond_to do |format|
      if @admin_role.update_attributes(params[:admin_role])
        format.html { redirect_to @admin_role, notice: 'Admin role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_roles/1
  # DELETE /admin_roles/1.json
  def destroy
    @admin_role = AdminRole.find(params[:id])
    @admin_role.destroy

    respond_to do |format|
      format.html { redirect_to admin_roles_url }
      format.json { head :no_content }
    end
  end
  
private

  def authenticate
    deny_access unless signed_in? ADMIN_TYPE
    #TODO add restriction ROLES
  end
  
end
