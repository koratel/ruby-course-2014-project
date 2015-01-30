module ProblemsHelper

  def external_url(url)
    url = url || ""
    return "" if url.blank?
    url.include?("http") ? url : ("http://" + url)
  end
end
