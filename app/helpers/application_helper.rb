module ApplicationHelper
  def rating_as_stars(rating)
    stars = '★' * rating
    empty_stars = '★' * (5 - rating)
    stars_span = content_tag(:span, stars, class:"rating-filled-stars")
    empty_stars_span = content_tag(:span, empty_stars, class:"rating-empty-stars")
    content_tag(:span, "#{stars_span}#{empty_stars_span}".html_safe, class:"rating-stars")
  end

  def generate_select_options(range)
    (range).to_a.map{|r| [r,r]}
  end

end
