module ApplicationHelper
  def full_title(page_title)
    default = "家計学園"
    if page_title.empty?
      default
    else
      "#{page_title} | #{default}"
    end
  end

  #経験値計算
  def culcurate_coin(items, costs)
      defalt_coin = 10
      times = Array.new
      d = Time.parse(Date.today.strftime("%Y-%m-%d")).to_i
      items.each do |item|
          times.push(((d-Time.parse(item).to_i)/100)/864)
      end
      times.each do |time|
          defalt_coin -= time
      end
      if defalt_coin < 1 then
          defalt_coin = 1
      end

      costs.length.times do |i|
          if costs[i].length < 10 then
              break
          end
          if i == costs.length - 1 then
              defalt_coin = 0
          end
      end

      return defalt_coin
  end

end
