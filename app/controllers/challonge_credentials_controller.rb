class ChallongeCredentialsController < ApplicationController
  def edit
    @credential = current_user.challonge_credential || current_user.build_challonge_credential

    render layout: 'modal_neutral'
  end

  def update
    @credential = current_user.challonge_credential || current_user.build_challonge_credential

    @credential.update(credential_params)

    head :ok
  end
  alias_method :create, :update

  def confirm_destroy
    render layout: 'modal_neutral'
  end

  def destroy
    current_user.challonge_credential&.destroy

    head :ok
  end

  private

    def credential_params
      params.require(:challonge_credential).permit(:username, :key)
    end
end
