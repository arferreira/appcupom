class PaymentOptionsController < ApplicationController
  # GET /payment_options
  # GET /payment_options.json
  def index
    @payment_options = PaymentOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_options }
    end
  end

  # GET /payment_options/1
  # GET /payment_options/1.json
  def show
    @payment_option = PaymentOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_option }
    end
  end

  # GET /payment_options/new
  # GET /payment_options/new.json
  def new
    @payment_option = PaymentOption.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_option }
    end
  end

  # GET /payment_options/1/edit
  def edit
    @payment_option = PaymentOption.find(params[:id])
  end

  # POST /payment_options
  # POST /payment_options.json
  def create
    @payment_option = PaymentOption.new(params[:payment_option])

    respond_to do |format|
      if @payment_option.save
        format.html { redirect_to @payment_option, notice: 'Payment option was successfully created.' }
        format.json { render json: @payment_option, status: :created, location: @payment_option }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_options/1
  # PUT /payment_options/1.json
  def update
    @payment_option = PaymentOption.find(params[:id])

    respond_to do |format|
      if @payment_option.update_attributes(params[:payment_option])
        format.html { redirect_to @payment_option, notice: 'Payment option was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_options/1
  # DELETE /payment_options/1.json
  def destroy
    @payment_option = PaymentOption.find(params[:id])
    @payment_option.destroy

    respond_to do |format|
      format.html { redirect_to payment_options_url }
      format.json { head :no_content }
    end
  end
end
