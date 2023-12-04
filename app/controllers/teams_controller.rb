class TeamsController < ApplicationController
  def edit
    load_team

    @char = @team.characters.first
  end

  def new
    team = Team.new(user_id: Current.user.id)
    team.update(Team.blank_team_attributes)

    redirect_to edit_team_path(team)
  end

  def confirm_destroy
    load_team
  end

  def destroy
    load_team
      
    @team.destroy

    redirect_to dashboard_path
  end

  def metadata
    load_team

    render layout: 'modal'    
  end

  def save
    load_team

    @team.update(team_attributes)
  end

  def create
    team_attributes = YAML.safe_load_file(params[:team_file])

    team = Team.create(user_id: Current.user.id, **team_attributes)

    Current.team = team

    session[:current_team_id] = team.id

    redirect_to edit_team_path(team)
  end

  def update
    load_team

    @team.update(team_attributes)

    head :ok
  end

  private

    def load_team
      @team = Team.find(params[:id])

      redirect_to dashboard_path if @team.user_id != Current.user.id
    end

    def team_attributes
      params.require(:team).permit(:name, :player_name, :palette_a, :palette_b)
    end
end
