class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def welcome
    date = DateTime.now
    @today_payments = Payment.order("paid_at").where(:paid_at => (date.beginning_of_day..date.end_of_day))
    @total_amount = @today_payments.collect(&:amount).sum
  end

  def index
    @users = User.all
  end

  def show
    @payments = @user.payments
    #@payment = @user.payments.build
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def all_payments
    @payments = Payment.all
    if params[:fl].present?
      @type = params[:fl]
      scope = Payment.order("paid_at")
      case(params[:fl])
        when "2day"
          date = DateTime.now
          @lists = scope.where(:paid_at => (date.beginning_of_day..date.end_of_day)) #.group_by { |p| p.paid_at.strftime("%B") }
        when "dd"
          date = 1.month.ago
          @lists = scope.where(:paid_at => (date.beginning_of_day..DateTime.now.utc.end_of_month)).group_by { |p| p.paid_at.strftime("%Y-%m-%d") }
        when "mm"
          date = 1.year.ago
          @lists = scope.where(:paid_at => (date.beginning_of_day..DateTime.now.utc.end_of_month)).group_by { |p| p.paid_at.strftime("%B") }
        when "yy"
          date = 10.years.ago
          @lists = scope.where(:paid_at => (date.beginning_of_day..DateTime.now.utc.end_of_year)).group_by { |p| p.paid_at.strftime("%Y") }
      end
      puts @lists.inspect
    else
      @type = "2day"
      date = DateTime.now
      @lists = Payment.where(:paid_at => (date.beginning_of_day..date.end_of_day))
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :mobile, :address, :city, :state, :country, :zip, :about, :profile_pic)
    end
end
