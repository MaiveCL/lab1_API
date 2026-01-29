class UnsubscribesController < ApplicationController
  before_action :set_subscriber

  def show
    @subscriber&.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Unsubscribed successfully." }
      format.json { head :no_content }
    end
  end

  private
    def set_subscriber
      @subscriber = Subscriber.find_by_token_for(:unsubscribe, params[:token])
    end
end
