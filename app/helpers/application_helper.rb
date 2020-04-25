module ApplicationHelper
  def exact_or_calculated(years, year)
    years.include?(year.to_i) ? 'exact' : 'calculated'
  end
end
