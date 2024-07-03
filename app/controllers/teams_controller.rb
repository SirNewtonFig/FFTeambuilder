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

  def create
    Team.where(user_id: Current.user.id).each(&:destroy)

    team_attributes = YAML.safe_load_file(params[:team_file])

    @team = Team.create(user_id: Current.user.id, **team_attributes)

    redirect_to teams_path
  end

  def update
    load_team

    @team.update(team_attributes)

    head :ok
  end

  private

    def load_team
      @team = Current.team

      @team.update(Team.blank_team_attributes) if @team.new_record?
    end

    def team_attributes
      params.require(:team).permit(:name, :player_name, :palette_a, :palette_b)
    end
end
