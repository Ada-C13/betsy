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

  def rating_average(reviews)
    sum = 0
    count = 0
    reviews.each do |review|
      sum += review.rating
      count += 1
    end
    return 0 if count == 0
    return  sum / count
  end

  def rating_count(reviews)
    count = 0
    reviews.each do |review|
      count += 1
    end
    return count
  end

end
