module ApplicationHelper
  def link_to_filter(date, count, type)
    txt = date.to_s + '('+ count.to_s + ')'
    if type == "yy"
      #link_to txt, search_posts_path(date, nil)
    else
      yy, mm = type.scan(/\d+/)
      #link_to txt, search_posts_path(yy, mm)
    end
  end
end
