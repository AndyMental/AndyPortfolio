class UpController < ApplicationController
  # Render's health check should be lightweight and not hit the database.
  def show
    render plain: "OK", status: :ok
  end
end
