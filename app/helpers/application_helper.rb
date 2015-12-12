module ApplicationHelper
  def site_name
    Rails.application.class.parent.to_s.titleize
  end

  def page_title(title = nil)
    title.blank? ? site_name : (title + ' | ' + site_name)
  end

  def bootstrap_class_for_alert(key)
    return "success" if key == "notice"
    return "danger" if key == "alert"
    key
  end
end
