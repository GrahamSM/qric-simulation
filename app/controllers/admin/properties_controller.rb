class Admin::PropertiesController < Admin::ApplicationController
  before_action :require_admin

  def index
    @properties = Property.all
  end

  def change_team
    user = User.find(session[:user_id])
    user.team_id = params[:team_id]
    user.save!
    redirect_to admin_properties_path, :notice => 'changed teams'
  end

  def get_ab_props
    alberta_props = Property.where(province: "Albert")
    return alberta_props
  end

  def get_bc_props
    bc_props = Property.where(province: "British Columbia")
    return bc_props
  end

  def get_sask_props
    sask_props = Property.where(province: "Saskatchewan")
    return sask_props
  end

  def get_mn_props
    mn_props = Property.where(province: "Manitoba")
    return mn_props
  end

  def get_on_props
    on_props = Property.where(province: "Ontario")
    return on_props
  end

  def get_qc_props
    qc_props = Property.where(province: "Quebec")
    return qc_props
  end

  def get_ns_props
    ns_props = Property.where(province: "Nova Scotia")
    return ns_props
  end

  def get_nb_props
    nb_props = Property.where(province: "New Brunswick")
    return nb_props
  end

  def get_nf_props
    nf_props = Property.where(province: "Newfoundland")
    return nf_props
  end

  def adjust_props(props, values)
    props.each do |prop|
        if prop.property_type_id == 1
          prop.value = prop.value*(1+values[0])
          prop.save!
        elsif prop.property_type_id == 2
           prop.value = prop.value*(1+values[1])
           prop.save!
        elsif prop.property_type_id == 3
          prop.value = prop.value*(1+values[2])
          prop.save!
        else
          prop.value = prop.value*(1+values[3])
          prop.save!
        end
    end
  end

  def shock1
    alberta_adjustments = [-0.06, -0.05, -0.05, -0.02]
    sask_adjustments = [0, -0.04, -0.03, -0.02]
    mn_adjustments = [-0.03, -0.02, -0.01, -0.01]
    on_adjustments = [0.02, 0.02, 0.02, 0.02]
    qc_adjustments = [0.01, 0.01, 0.01, 0.01]
    alberta_props = get_ab_props
    sask_props = get_sask_props
    mn_props = get_mn_props
    on_props = get_on_props
    qc_props = get_qc_props
    adjust_props(alberta_props, alberta_adjustments)
    adjust_props(sask_props, sask_adjustments)
    adjust_props(mn_props, mn_adjustments)
    adjust_props(on_props, on_adjustments)
    adjust_props(qc_props, qc_adjustments)
    redirect_to admin_properties_path, :notice => 'Crude oil shock executed'
	end


  def shock2
    adjustments = [-0.01, 0.05, 0, -0.02]
    alberta_props = get_ab_props
    bc_props = get_bc_props
    sask_props = get_sask_props
    mn_props = get_mn_props
    on_props = get_on_props
    qc_props = get_qc_props
    ns_props = get_ns_props
    nb_props = get_nb_props
    nf_props = get_nf_props
    adjust_props(alberta_props, adjustments)
    adjust_props(bc_props, adjustments)
    adjust_props(sask_props, adjustments)
    adjust_props(mn_props, adjustments)
    adjust_props(on_props, adjustments)
    adjust_props(qc_props, adjustments)
    adjust_props(ns_props, adjustments)
    adjust_props(nb_props, adjustments)
    adjust_props(nf_props, adjustments)
    redirect_to admin_properties_path, :notice => 'Industrial shock executed'
	end


  def shock3
    adjustments = [0, 0.04, 0, -0.05]
    alberta_props = get_ab_props
    bc_props = get_bc_props
    sask_props = get_sask_props
    mn_props = get_mn_props
    on_props = get_on_props
    qc_props = get_qc_props
    ns_props = get_ns_props
    nb_props = get_nb_props
    nf_props = get_nf_props
    adjust_props(alberta_props, adjustments)
    adjust_props(bc_props, adjustments)
    adjust_props(sask_props, adjustments)
    adjust_props(mn_props, adjustments)
    adjust_props(on_props, adjustments)
    adjust_props(qc_props, adjustments)
    adjust_props(ns_props, adjustments)
    adjust_props(nb_props, adjustments)
    adjust_props(nf_props, adjustments)
    redirect_to admin_properties_path, :notice => 'E-Commerce shock executed'
  end

  def shock4
    adjustments = [-0.03, -0.06, -0.07, -0.04]
    alberta_props = get_ab_props
    bc_props = get_bc_props
    sask_props = get_sask_props
    mn_props = get_mn_props
    on_props = get_on_props
    qc_props = get_qc_props
    ns_props = get_ns_props
    nb_props = get_nb_props
    nf_props = get_nf_props
    adjust_props(alberta_props, adjustments)
    adjust_props(bc_props, adjustments)
    adjust_props(sask_props, adjustments)
    adjust_props(mn_props, adjustments)
    adjust_props(on_props, adjustments)
    adjust_props(qc_props, adjustments)
    adjust_props(ns_props, adjustments)
    adjust_props(nb_props, adjustments)
    adjust_props(nf_props, adjustments)
    redirect_to admin_properties_path, :notice => 'Interest rate and OSFI shock executed'
	end

  def shock5
    bc_adjustments = [0.05, 0.01, 0.08, 0.03]
    on_adjustments = [0.05, 0.01, 0.07, 0.02]
    qc_adjustments = [0.02, 0.01, 0.03, 0.01]
    bc_props = get_bc_props
    on_props = get_on_props
    qc_props = get_qc_props
    adjust_props(bc_props, bc_adjustments)
    adjust_props(on_props, on_adjustments)
    adjust_props(qc_props, qc_adjustments)
    redirect_to admin_properties_path, :notice => 'Foreign investment shock executed'
  end

  def end_game
    lowest_end_cash = []
    highest_end_prop = []
    most_acquisitions = []
    most_developments = []
    most_props = []
    most_ind_props = []
    most_mr_props = []
    most_office_props = []
    most_retail_props = []
    #Find incentive achievements for each team in the game
    Team.all.each do |team|
      @incentives = team.calcIncentives();
      @incentives_list = Incentive.all
      if @incentives[:propertyType1]
        team.cash_balance += @incentives_list.where(:calculation_key => "propertyType1Count")[0].value
      end
      if @incentives[:propertyType2]
        team.cash_balance += @incentives_list.where(:calculation_key => "propertyType2Count")[0].value
      end
      if @incentives[:propertyType3]
        team.cash_balance += @incentives_list.where(:calculation_key => "propertyType3Count")[0].value
      end
      if @incentives[:propertyType4]
        team.cash_balance += @incentives_list.where(:calculation_key => "propertyType4Count")[0].value
      end
      if @incentives[:province1]
        team.cash_balance += @incentives_list.where(:calculation_key => "province1Count")[0].value
      end
      if @incentives[:province2]
        team.cash_balance += @incentives_list.where(:calculation_key => "province2Count")[0].value
      end
      if @incentives[:province3]
        team.cash_balance += @incentives_list.where(:calculation_key => "province3Count")[0].value
      end
      if @incentives[:province4]
        team.cash_balance += @incentives_list.where(:calculation_key => "province4Count")[0].value
      end
      if @incentives[:province5]
        team.cash_balance += @incentives_list.where(:calculation_key => "province5Count")[0].value
      end
      if @incentives[:province6]
        team.cash_balance += @incentives_list.where(:calculation_key => "province6Count")[0].value
      end
      if @incentives[:traded1]
        team.cash_balance += @incentives_list.where(:calculation_key => "traded1Count")[0].value
      end
      if @incentives[:traded2]
        team.cash_balance += @incentives_list.where(:calculation_key => "traded2Count")[0].value
      end
      if @incentives[:traded3]
        team.cash_balance += @incentives_list.where(:calculation_key => "traded3Count")[0].value
      end
      if @incentives[:developments1]
        team.cash_balance += @incentives_list.where(:calculation_key => "developments1Count")[0].value
      end
      if @incentives[:developments2]
        team.cash_balance += @incentives_list.where(:calculation_key => "developments2Count")[0].value
      end
      if @incentives[:developments3]
        team.cash_balance += @incentives_list.where(:calculation_key => "developments3Count")[0].value
      end
      lowest_end_cash << @incentives[:cashBalance]
      highest_end_prop << @incentives[:totalPropertyValue]
      most_acquisitions << @incentives[:acquisitions_made]
      most_developments << @incentives[:developmentsCount]
      most_props << @incentives[:propertiesCount]
      most_ind_props << @incentives[:industrial_properties]
      most_mr_props << @incentives[:multi_res_properties]
      most_office_props << @incentives[:office_properties]
      most_retail_props << @incentives[:retail_properties]
    end
    #Store the index of the team for each achieved incentive
    lowest_end_cash_team = lowest_end_cash.rindex(lowest_end_cash.min)+1
    highest_end_prop_team = highest_end_prop.rindex(highest_end_prop.max)+1
    most_aquisitions_team = most_acquisitions.rindex(most_acquisitions.max)+1
    most_developments_team = most_developments.rindex(most_developments.max)+1
    most_props_team = most_props.rindex(most_props.max)+1
    most_ind_props_team = most_ind_props.rindex(most_ind_props.max)+1
    most_mr_props_team = most_mr_props.rindex(most_mr_props.max)+1
    most_office_props_team = most_office_props.rindex(most_office_props.max)+1
    most_retail_props_team = most_retail_props.rindex(most_retail_props.max)+1
    #Apply appropriate rewards to each team who achieved a game-level incentive
    x1 = Team.all.where(:id => lowest_end_cash_team)[0]
    x1.cash_balance += Incentive.all.where(:calculation_key => "cashBalance")[0].value
    x1.save!
    x2 = Team.all.where(:id => highest_end_prop_team)[0]
    x2.cash_balance += Incentive.all.where(:calculation_key => "totalPropertyValue")[0].value
    x2.save!
    x3 = Team.all.where(:id => most_aquisitions_team)[0]
    x3.cash_balance += Incentive.all.where(:calculation_key => "tradedPropertiesCount")[0].value
    x3.save!
    x4 = Team.all.where(:id => most_developments_team)[0]
    x4.cash_balance += Incentive.all.where(:calculation_key => "developmentsCount")[0].value
    x4.save!
    x5 = Team.all.where(:id => most_props_team)[0]
    x5.cash_balance += Incentive.all.where(:calculation_key => "propertiesCount")[0].value
    x5.save!
    x6 = Team.all.where(:id => most_ind_props_team)[0]
    x6.cash_balance += Incentive.all.where(:calculation_key => "propertyType2Count")[0].value
    x6.save!
    x7 = Team.all.where(:id => most_mr_props_team)[0]
    x7.cash_balance += Incentive.all.where(:calculation_key => "propertyType1Count")[0].value
    x7.save!
    x8 = Team.all.where(:id => most_office_props_team)[0]
    x8.cash_balance += Incentive.all.where(:calculation_key => "propertyType3Count")[0].value
    x8.save!
    x9 = Team.all.where(:id => most_retail_props_team)[0]
    x9.cash_balance += Incentive.all.where(:calculation_key => "propertyType4Count")[0].value
    x9.save!
    redirect_to admin_properties_path, :notice => 'Ended game and updated incentives'
  end
end
