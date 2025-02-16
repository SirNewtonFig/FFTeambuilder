class TeamsController < ApplicationController
  def index
    @teams = Team.where(user_id: Current.user.id).order(updated_at: :desc)
      .includes(:events)
  end
  
  def edit
    load_team

    @char = @team.characters.first
  end

  def new
    team = Team.new(user_id: Current.user.id)
    team.player_name = Current.user.username if Current.user.persisted?
    team.update(Team.blank_team_attributes)

    redirect_to edit_team_path(team)
  end

  def confirm_destroy
    load_team
  end

  def destroy
    load_team
      
    @team.destroy

    @referer_attrs = Rails.application.routes.recognize_path(request.referrer)
  end

  def metadata
    load_team

    render layout: 'modal'    
  end

  def clone
    load_team

    new_team = @team.dup
    new_team.user = Current.user

    new_team.save

    head :ok
  end

  def export
    load_team

    begin
      f = Tempfile.new('team', Rails.root.join('tmp'))
      f.write(@team.attributes.except('id', 'created_at', 'updated_at', 'user_id').to_yaml)
      f.open

      File.open(f.path, 'r') do |ff|
        send_data(ff.read, filename: "#{@team.name}.yml")
      end
    ensure
      f.close
      f.unlink
    end
  end

  def import
    teams = params[:team_files].map do |file|
      team_attributes = YAML.safe_load_file(file)

      Team.create(user_id: Current.user.id, **team_attributes)
    end

    if params[:team_files].count == 1
      redirect_to team_path(teams.first)
    else
      redirect_to teams_path
    end
  end

  def update
    load_team

    raise 'unauthorized' unless @team.mine?

    @team.update(team_attributes)
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
