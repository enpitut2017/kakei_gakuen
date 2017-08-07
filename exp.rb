def level_culcurate (exp)
    #exp = @user.exp
    level = 0
    levelup_table = [0, 10, 20]
    size = levelup_table.size
    tmpexp = exp
    while (level < size) and (tmpexp -= levelup_table[level]) >= 0 do
        level += 1
    end
    return level
end

puts level_culcurate 40
