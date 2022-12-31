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

  def download
    load_team

    f = Tempfile.new('team', Rails.root.join('tmp'))
    f.write(@team.attributes.except('id', 'created_at', 'updated_at', 'user_id').to_yaml)

    send_file(f.path, filename: 'team.yml')
    f.open
  rescue
    f.close
    f.unlink
  end

  def create
    Team.where(user_id: session[:user_id]).each(&:destroy)

    team_attributes = YAML.safe_load_file(params[:team_file])

    @team = Team.create(user_id: session[:user_id], **team_attributes)

    redirect_to teams_path
  end

  private

    def load_team
      @team = Team.find_or_initialize_by(user_id: session[:user_id])

      @team.update(data: Team::DEFAULT_DATA.dup) if @team.new_record?
    end
end
