module ProblemsHelper

  def external_url(url)
    return "#" if url.nil?
    url.include?("http") ? url : "http://" + url
  end
end
