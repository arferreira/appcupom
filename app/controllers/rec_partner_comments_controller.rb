# encoding: utf-8
class RecPartnerCommentsController < ApplicationController

  def index
    @rec_partner_comments = RecPartnerComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rec_partner_comments }
    end
  end

  def create
    @comment = RecPartnerComment.new params[:rec_partner_comment]
    rec_partner = RecommendPartner.find params[:object_id]

    @comment[:recommend_partner_id] = rec_partner.id
    @comment[:user_id] = current_user.id
    
    #timeline
    if @comment.save
      current_user.share TimelineType.rec_partner_comment, {:rec_partner_comment_id => @comment.id} unless @comment.nil?
      current_user.share_social @comment.facebook_resume , PrivacyType.rec_partner_comment
    end
    
    flash[:notice] = "Comentário enviado!"
    respond_to do |format|
      format.html {redirect_to [rec_partner.partner, rec_partner]}
      format.js {render '/comments/create', :status => 250}
    end
  end
  
  # DELETE /partner_comments/1
  # DELETE /partner_comments/1.json
  def destroy
    @comment = RecPartnerComment.find(params[:id])
    
    @comments_num = PartnerComment.find(:all, :conditions => ["recommend_partner_id = ?", @comment.recommend_partner.id]).count - 1
   
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to recommend_partner_path }
      format.js {render :status => 250}
    end
  end
  
  
  # GET /rec_partner_comments
  # GET /rec_partner_comments.json
 # def index
  #  @rec_partner_comments = RecPartnerComment.all

   # respond_to do |format|
   #   format.html # index.html.erb
   #   format.json { render json: @rec_partner_comments }
  #  end
  #end

  # GET /rec_partner_comments/1
  # GET /rec_partner_comments/1.json
  #def show
  #  @rec_partner_comment = RecPartnerComment.find(params[:id])

  #  respond_to do |format|
  #    format.html # show.html.erb
   #   format.json { render json: @rec_partner_comment }
  #  end
  #end

  # GET /rec_partner_comments/new
  # GET /rec_partner_comments/new.json
  #def new
  #  @rec_partner_comment = RecPartnerComment.new
  #  @partner = Partner.find(params[:partner_id])
  #  @recommend_partner = RecommendPartner.find(params[:recommend_partner_id])

   # respond_to do |format|
   #   format.html # new.html.erb
   #   format.json { render json: @rec_partner_comment }
   # end
  #end

  # GET /rec_partner_comments/1/edit
 # def edit
  #  @rec_partner_comment = RecPartnerComment.find(params[:id])
 # end

  # POST /rec_partner_comments
  # POST /rec_partner_comments.json
  #def create
    #@rec_partner_comment = RecPartnerComment.new(params[:rec_partner_comment])
    #@recomend_partner = RecommendPartner.find(params[:recommend_partner_id])
    #@user = current_user
    
    #@rec_partner_comment.recomend_partner = @recomend_partner
    #@recommend_partner.user    = @user

    #respond_to do |format|
      #if @rec_partner_comment.save
       # format.html { redirect_to @rec_partner_comment, notice: 'Rec partner comment was successfully created.' }
       # format.json { render json: @rec_partner_comment, status: :created, location: @rec_partner_comment }
      #else
      #  format.html { render action: "new" }
     #   format.json { render json: @rec_partner_comment.errors, status: :unprocessable_entity }
    #  end
   # end
  #end

  # PUT /rec_partner_comments/1
  # PUT /rec_partner_comments/1.json
  #def update
  #  @rec_partner_comment = RecPartnerComment.find(params[:id])

   # respond_to do |format|
   #   if @rec_partner_comment.update_attributes(params[:rec_partner_comment])
   #     format.html { redirect_to @rec_partner_comment, notice: 'Rec partner comment was successfully updated.' }
   #     format.json { head :no_content }
   #   else
    #    format.html { render action: "edit" }
    #    format.json { render json: @rec_partner_comment.errors, status: :unprocessable_entity }
    #  end
   # end
  #end

  # DELETE /rec_partner_comments/1
  # DELETE /rec_partner_comments/1.json
  #def destroy
  #  @rec_partner_comment = RecPartnerComment.find(params[:id])
  #  @rec_partner_comment.destroy

  #  respond_to do |format|
  #    format.html { redirect_to rec_partner_comments_url }
   #   format.json { head :no_content }
   # end
  #end
end
