module ApplicationHelper
  def exact_or_calculated(years, year)
    years.include?(year.to_i) ? 'exact' : 'calculated'
  end

  def model_checked(input, params)
    if params && params[:model]
      params[:model] == input ? ' checked="checked"'.html_safe : ''
    elsif input == 'Logistical'
      ' checked="checked"'.html_safe
    else
      ''
    end
  end
end
