require "date"
require 'time'
class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include SessionsHelper

    def culcurarte_exp(items)
        defalt_exp = 10
        times = Array.new
        d = Time.parse(Date.today.strftime("%Y-%m-%d")).to_i
        items.each do |item|
            times.push(((d-Time.parse(item).to_i)/100)/864)
        end
        times.each do |time|
            defalt_exp -= time
        end
        if defalt_exp < 1 then
            defalt_exp = 1
        end
    end
end
