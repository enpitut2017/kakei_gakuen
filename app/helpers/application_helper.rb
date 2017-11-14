module ApplicationHelper
  def full_title(page_title)
    default = "家計学園"
    if page_title.empty?
      default
    else
      "#{page_title} | #{default}"
    end
  end
end
