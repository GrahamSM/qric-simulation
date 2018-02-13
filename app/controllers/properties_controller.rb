class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy]

  # GET /properties
  # GET /properties.json
  def index
    @properties = Property.all
    @teams = Team.order(:id)
  end
  # GET /properties/1
  # GET /properties/1.json
  def show
    # @properties = Property.where(team_id: params[:id].to_i)
    # render json: @properties
  end

  def new
    @property = Property.new
  end

  def edit
  end

  def calculateIncentives
    #
    # Property.where(:team_id => 'x', :property_type => 'Multi-Res').count >= 7
    # Property.where(:team_id => 'x', :property_type => 'Industrial').count >= 4
    # Property.where(:team_id => 'x', :property_type => 'Office').count >= 3
    # Property.where(:team_id => 'x', :property_type => 'Retail').count >= 7
    # Property.where(:team_id => 'x', :location => 'Alberta').count >= 4
    # Property.where(:team_id => 'x', :location => 'BC').count >= 4
    # Property.where(:team_id => 'x', :location => 'NS').count >= 3
    # Property.where(:team_id => 'x', :location => 'Ontario').count >= 3
    # Property.where(:team_id => 'x', :location => 'Quebec').count >= 3
    # Property.where(:team_id => 'x', :location => 'Saskatchewan').count >= 2
    # #then goes to acquisitions??
    # TradeRequest.where(:requester => 'x',:completed => 'true').or(:requestee => 'x',:completed => 'true').count >= 10,20,30
    # Property.where(:team_id => 'x', :developed => 'true').count >= 2,5,8
    # Team.maximum(:cash_balance)
    # Team.minimum(:cash_balance)
    #most acquisitions, developments, properties, most x type properties
  # POST /properties
  # POST /properties.json
  end

  def develop
    @property = Property.find(params[:id])
    flash = {}
    if @property.development
      if @property.development.used
        flash[:error] = "You have already developed this property"
        render 'show'
        redirect_to users_path
      elsif !(Team.find(current_user.team_id).can_drop_cash_balance(@property.development.cost))
        flash[:error] = "You cannot afford to develop this property" 
        render 'show'
        redirect_to users_path
      else
        message = @property.develop(current_user.team_id)
        @development = @property.development
        @development.save!
        flash[:success] = message
        flash[:notice] =  'Development was successfully initiated.'
        redirect_to users_path
      end
    end
  end

  def create
    @property = Property.new(property_params)
    if @property.save
      format.html { redirect_to @property, notice: 'Property was successfully created.' }
      format.json { render :show, status: :created, location: @property }
    else
      format.html { render :new }
      format.json { render json: @property.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update
    if @property.update(property_params)
      format.html { redirect_to @property, notice: 'Property was successfully updated.' }
      format.json { render :show, status: :ok, location: @property }
      format.html { render :edit }
    end
  end
  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy
    format.html { redirect_to properties_url, notice: 'Property was successfully destroyed.' }
    format.json { head :no_content }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:team_id, :property_type, :property_values_id, :in_development, :development_id, :city, :province)
    end

end
