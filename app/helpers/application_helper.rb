# frozen_string_literal: true

module ApplicationHelper
  def classifier_bar_color(status)
    return "success" if status == "completed"
    return "danger" if status == "failed"
    return "secondary" if status == "queued"
    return "warning"
  end
end
