class TeamsController < ApplicationController
  def index
    load_team

    @char = @team.characters.first
  end

  def destroy
    Team.find(params[:id])
      &.destroy

    redirect_to teams_path
  end

  def export
    load_team

    render layout: 'modal'    
  end

  def download
    load_team

    @team.update(team_attributes)

    f = Tempfile.new('team', Rails.root.join('tmp'))
    f.write(@team.attributes.except('id', 'created_at', 'updated_at', 'user_id').to_yaml)

    send_file(f.path, filename: "#{@team.name}.yml")
    f.open
  ensure
    f.close
    f.unlink
  end

  def create
    Team.where(user_id: session[:user_id]).each(&:destroy)

    team_attributes = YAML.safe_load_file(params[:team_file])

    @team = Team.create(user_id: session[:user_id], **team_attributes)

    redirect_to teams_path
  end

  def update
    load_team

    @team.update(team_attributes)

    head :ok
  end

  private

    def load_team
      @team = Team.find_or_initialize_by(user_id: session[:user_id])

      @team.update(palette_a: 'blue', palette_b: 'red', data: Team::DEFAULT_DATA.dup) if @team.new_record?
    end

    def team_attributes
      params.require(:team).permit(:name, :player_name, :palette_a, :palette_b)
    end
end
