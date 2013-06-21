# encoding: utf-8
class PartnerCommentsController < ApplicationController
  #before_filter :get_partner
    
  # GET /partner_comments
  # GET /partner_comments.json
  def index
    @partner_comments = PartnerComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @partner_comments }
    end
  end

  # POST /partner_comments
  # POST /partner_comments.json
  def create
    comment = params[:partner_comment]
    @user = current_user
    comment[:user_id] = @user.id
    @comment = PartnerComment.create!(comment)
    @comments_num = PartnerComment.find_all_by_partner_id(@comment.partner.id).count
    @current_user = current_user
   
    flash[:notice] = "Comentário enviado!"
    respond_to do |format|
      format.html { redirect_to partner_path }
      format.js {render :status => 250}
    end
  end

  # DELETE /partner_comments/1
  # DELETE /partner_comments/1.json
  def destroy
    @comment = PartnerComment.find(params[:id])
    @comments_num = PartnerComment.find(:all, :conditions => ["partner_id = ?", @comment.partner.id]).count - 1
   
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to partner_path }
      format.js {render :status => 250}
    end
  end
  
  
end
