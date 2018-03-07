# frozen_string_literal: true

module ApplicationHelper
	def breadcrumb(items)
		content_tag :nav do
      content_tag :ol, class: "breadcrumb" do
        items.map do |item|
          content_tag :li, class: "breadcrumb-item #{item[:active] ? "active" : ""}" do
            item[:el]
          end
        end.join.html_safe
      end
    end
  end

  def classifier_bar_color(status)
    return "success" if status == "completed"
    return "danger" if status == "failed"
    return "secondary" if status == "queued"
    return "warning"
  end
end
