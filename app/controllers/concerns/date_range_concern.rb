module DateRangeConcern
  extend ActiveSupport::Concern

  included do
    before_action :ensure_start_and_end_date_present
  end

  private

  def ensure_start_and_end_date_present
    if params[:start_date].blank? || params[:end_date].blank?
      raise ValidationError, "start_date or end_date missing"
    end
  end
end