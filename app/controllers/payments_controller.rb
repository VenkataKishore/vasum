class PaymentsController < ApplicationController
  before_action :load_user, except: [:direct_payment]
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def index
    @payments = @user.payments
  end

  def show
  end

  def new
    @payment = @user.payments.build
  end

  def edit
  end

  def create
    nparams = payment_params
    date = payment_params.delete("paid_at")
    paidat = DateTime.strptime(date, "%m/%d/%Y").strftime("%Y/%m/%d")
    nparams.merge!(paid_at: paidat)
    @payment = @user.payments.build(nparams)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to user_path(@user), notice: 'payment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to user_path(@user), notice: 'payment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: 'payment was successfully destroyed.' }
    end
  end

  def import
  end

  def import_payments
  end

  def direct_payment
    if request.get?
     @payment = Payment.new
    else
      @user = User.find(params[:payment][:user_id])
      nparams = payment_params
      date = payment_params.delete("paid_at")
      paidat = DateTime.strptime(date, "%m/%d/%Y").strftime("%Y/%m/%d")
      nparams.merge!(paid_at: paidat)
      @payment = @user.payments.build(nparams)

      respond_to do |format|
        if @payment.save
          format.html { redirect_to user_path(@user), notice: 'payment was successfully created.' }
        else
          format.html { render :back }
        end
      end
    end
  end

  private
    def load_user
      @user = User.find(params[:user_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:user_id, :paid_at, :paid_to, :amount)
    end
end
