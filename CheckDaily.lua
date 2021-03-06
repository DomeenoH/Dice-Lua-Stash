-- .Ding打卡脚本~给你的骰娘装上这个，就可以实现每日打卡功能了！
-- .Ding打卡 .DingData查看打卡数据
-- 作者 MSCxar0293
-- 版本 v1.0
-- 更新日期 20210711
-- 柴刀赋予灵魂（计时逻辑）
-- 多米诺修改 20211205
msg_order = {}

function checkDaily(msg)
    local userTotalCheck = getUserConf(msg.fromQQ, "总打卡次数", 0) -- 取总打卡次数
    local userComboCheck = getUserConf(msg.fromQQ, "连续打卡", 0) -- 取连续打卡天数
    local userCheckOne = getUserConf(msg.fromQQ, "打卡时间", 0) -- 取上次打卡时间
    local date = os.date("%j"); -- 系统时间,一年中的XXX天
    local bonus_arknights = math.random(100)

    -- 判断是否断签
    local boolDuanQian = 0
    if (date == 1) then -- 如果今天是一年中的第一天
        if (math.fmod(os.date("%Y") - 1, 4) == 0) then -- 判断去年是不是闰年
            boolDuanQian = date + 366 - userCheckOne
        else
            boolDuanQian = date + 365 - userCheckOne
        end
    else
        boolDuanQian = date - userCheckOne
    end

    -- 限制今日重复打卡次数为5
    local ding_limit = 1
    local ding_ddl = 10
    local today_ding = getUserToday(msg.fromQQ, "dingtimes", 0) -- 判断今日是否打卡

    if (today_ding >= ding_ddl) then
        return "{nick}在{self}空荡荡的猫砂盆里徒劳地翻找着什么。"
    elseif (today_ding >= ding_limit) then
        if (bonus_arknights <= 30) then
            today_ding = today_ding + 1
            setUserToday(msg.fromQQ, "dingtimes", today_ding)
            local random = math.random(0, 1)
            if (random == 0) then
                return "{nick}第" .. math.floor(today_ding) ..
                           "次在{self}的猫砂盆里奋力翻找着什么，但一无所获。"
            else
                setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) + 1)
                local coin = getUserConf(msg.fromQQ, "猫猫金币", 0)
                return "{nick}第" .. math.floor(today_ding) ..
                           "次将头探向猫砂盆……你没有找到寻访券，但挖到了一枚印着猫猫图案的金币。\n你数了数口袋中的金币，现在有" ..
                           math.floor(coin) .. "枚。"
            end
        elseif (bonus_arknights <= 70) then
            today_ding = today_ding + 1
            setUserToday(msg.fromQQ, "dingtimes", today_ding)
            -- local draw_arknights = math.random(5)
            -- local draw_result = math.random()
            return draw_eventI(msg)
        elseif (bonus_arknights <= 90) then
            today_ding = today_ding + 1
            setUserToday(msg.fromQQ, "dingtimes", today_ding)
            -- local draw_arknights = math.random(2)
            -- local draw_result = math.random()
            return draw_eventII(msg)
        elseif (bonus_arknights <= 100) then
            today_ding = today_ding + 1
            setUserToday(msg.fromQQ, "dingtimes", today_ding)
            -- local draw_arknights = math.random(3)
            -- local draw_result = math.random()
            return draw_eventIII(msg)
        else
            return
                "如果你看到这条消息，说明出bug了，请握紧这条聊天记录，尽快找到多米诺并说明情况，他会处理一切的。"
            -- setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
            -- return "{nick}第"..math.floor(today_ding).."次翻找着{self}的猫砂盆，从里面找到了"..math.floor(bonus_arknights).."张十连寻访券！"
            -- 测试信息：\nuserTotalCheck="..math.floor(userTotalCheck).."\nuserComboCheck="..math.floor(userComboCheck).."\ndate="..date.."\nuserCheckOne="..userCheckOne.."\nboolDuanQian="..boolDuanQian..""
        end
    else
        today_ding = today_ding + 1
        setUserToday(msg.fromQQ, "dingtimes", today_ding)
    end

    if (userTotalCheck == 0) then
        -- 第一次打卡者的特殊处理
        setUserConf(msg.fromQQ, "打卡时间", date)
        setUserConf(msg.fromQQ, "连续打卡", 1) -- 设置连续打卡天数为1
        setUserConf(msg.fromQQ, "总打卡次数", 1) -- 设置总打卡天数为1
        local userTotalCheck = getUserConf(msg.fromQQ, "总打卡次数", 0)
        local userComboCheck = getUserConf(msg.fromQQ, "连续打卡", 0)
        local bonus_arknights = math.random(5)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
        return "{nick}今日铲屎成功！\n你在猫砂盆中翻出了" .. math.floor(bonus_arknights) ..
                   "张十连寻访券！\n您已累计铲屎" .. math.floor(userTotalCheck) .. "天！\n连续铲屎" ..
                   math.floor(userComboCheck) .. "天~"

    else
        if (boolDuanQian ~= 1) then
            -- 连续打卡中断
            setUserConf(msg.fromQQ, "打卡时间", date)
            setUserConf(msg.fromQQ, "连续打卡", 1) -- 设置连续打卡天数为1
            setUserConf(msg.fromQQ, "总打卡次数", getUserConf(msg.fromQQ, "总打卡次数", 0) + 1) -- 总打卡天数+1
            local userTotalCheck = getUserConf(msg.fromQQ, "总打卡次数", 0)
            local userComboCheck = getUserConf(msg.fromQQ, "连续打卡", 0)
            local bonus_arknights = math.random(5)
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
            return "{nick}今日铲屎成功！\n你在猫砂盆中翻出了" .. math.floor(bonus_arknights) ..
                       "张十连寻访券！\n您已累计铲屎" .. math.floor(userTotalCheck) ..
                       "天！\n连续铲屎" .. math.floor(userComboCheck) .. "天~"

        else
            -- 正常连续打卡的情况
            setUserConf(msg.fromQQ, "打卡时间", date)
            setUserConf(msg.fromQQ, "连续打卡", getUserConf(msg.fromQQ, "连续打卡", 0) + 1)
            setUserConf(msg.fromQQ, "总打卡次数", getUserConf(msg.fromQQ, "总打卡次数", 0) + 1)
            local userTotalCheck = getUserConf(msg.fromQQ, "总打卡次数", 0)
            local userComboCheck = getUserConf(msg.fromQQ, "连续打卡", 0)
            local bonus_arknights = math.random(5)
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
            return "{nick}今日铲屎成功！\n你在猫砂盆中翻出了" .. math.floor(bonus_arknights) ..
                       "张十连寻访券！\n您已累计铲屎" .. math.floor(userTotalCheck) ..
                       "天！\n连续铲屎" .. math.floor(userComboCheck) .. "天~"

        end
    end
end -- function的end

msg_order["铲屎"] = "checkDaily"

-- 以下为查询打卡信息
function dingdata(msg)
    local userTotalCheck = getUserConf(msg.fromQQ, "总打卡次数", 0)
    local userComboCheck = getUserConf(msg.fromQQ, "连续打卡", 0)
    local userCheckOne = getUserConf(msg.fromQQ, "打卡时间", 0)
    local today_ding = getUserToday(msg.fromQQ, "dingtimes", 0)
    local coin = getUserConf(msg.fromQQ, "猫猫金币", 0)
    local bonus_arknights = getUserToday(msg.fromQQ, "today_draw_max", 0)
    return "{nick}已经累计铲屎" .. math.floor(userTotalCheck) .. "天，连续铲屎" ..
               math.floor(userComboCheck) .. "天了喵——\n今日还有" .. math.floor(10 - today_ding) ..
               "次机会在铲屎时遇到事件！\n口袋中现在有" .. math.floor(coin) .. "枚金币和" ..
               math.floor(3 - bonus_arknights) .. "张十连寻访券！"
end

-- 以下为测试
function deBug(msg)
    setUserToday(msg.fromQQ, "dingtimes", 1)
    return "已重置铲屎次数"
end

msg_order["第八阿哥"] = "deBug"

-- function test(msg)
--  local cat=tonumber(string.sub(msg.fromMsg, -2, -2))
--  local eve=tonumber(string.sub(msg.fromMsg, -1, -1))
--
--  return ""
-- end
-- msg_order["吃葡萄不吐葡萄皮"] = "test"

-- 以下为事件
function draw_eventI(msg)
    local draw_arknights = math.random(18)
    local draw_result = math.random(0, 1)
    local today_ding = getUserToday(msg.fromQQ, "dingtimes", 0)
    if (draw_arknights == 1) then
        local event = "大号猫砂盆"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "呆比换了大号猫砂盆，你在猫砂盆里刨了半天，什么也没有找到。"
        elseif (draw_result == 1) then
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 1)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "呆比换了大号猫砂盆，你在猫砂盆里刨了半天，只找到1张寻访券——"
        else
        end
    elseif (draw_arknights == 2) then
        local event = "黄金咖啡"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "你挖到了一坨散发出浓郁咖啡香气的玩意，你决定不深究它是什么"
        else
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "你挖到了一坨散发出浓郁咖啡香气的玩意，你决定不深究它是什么"
        end
    elseif (draw_arknights == 3) then
        local event = "埋山山"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "你越挖越深，突然你挖到了一只被大家埋起来的山山，你决定装作没看见把山山埋回去。"
        else
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "你越挖越深，突然你挖到了一只被大家埋起来的山山，你决定挖深点埋掉山山免得被其他人挖出来。"
        end
    elseif (draw_arknights == 4) then
        local event = "一堆神秘金币"
        local coinget = math.random(3, 10)
        setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) + coinget)
        local coin = getUserConf(msg.fromQQ, "猫猫金币", 0)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" .. "你挖到了" .. math.floor(coinget) ..
                "枚印着猫猫图案的金币。\n你数了数口袋中的金币，现在有" .. math.floor(coin) ..
                "枚。"
    elseif (draw_arknights == 5) then
        local event = "呆胶布"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" ..
                "呆比乱玩胶带，把铲子粘在地上了！你根本拿不起来，只能放弃铲屎的想法。"
    elseif (draw_arknights == 6) then
        local event = "羊脂玉猫砂盆"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" ..
                "当你在铲便便的时候，你听见面前白玉制成的猫砂盆里突然有声音呼唤你的名字，你本能地答应一声，然后被吸进去了！"
    elseif (draw_arknights == 7) then
        local event = "紫金红猫砂盆"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" ..
                "当你在铲便便的时候，你听见面前紫金制成的猫砂盆里突然有声音呼唤你的名字，你本能地答应一声，然后被吸进去了！"
    elseif (draw_arknights == 8) then
        local event = "急性肠炎"
        local draw_arknights = 3 - getUserToday(msg.fromQQ, "today_draw_max", 0)
        local draw_result = math.random(1, 3)
        if (draw_result > draw_arknights) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "呆比生病了！吓得多米诺赶紧去给呆比看病，你没有足够的寻访券能用来帮忙……"
        else
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) + draw_result)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "呆比生病了！吓得多米诺赶紧去给呆比看病，你也出了一份力把自己的" ..
                       math.floor(draw_result) .. "张寻访券交给了多米诺。"
        end
    elseif (draw_arknights == 9) then
        local event = "沉睡恶兽"
        local draw_result = math.random(0, 3)
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "呆比今天好困，在猫砂盆里睡着啦！你铲屎的难度变高了，你小心翼翼地铲了好久，最终也没能挖出寻访券。"
        else
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "呆比今天好困，在猫砂盆里睡着啦！你铲屎的难度变高了，你小心翼翼地铲了好久，最终挖出了" ..
                       math.floor(draw_result) .. "张寻访券。"
        end
    elseif (draw_arknights == 11) then
        local event = "禁止色色"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" ..
                "你在猫砂里面挖到了奇怪的东西，拿出来仔细一看居然是一张色图，还没等你仔细品鉴，突然从旁边跳出一只浪客狗狗一刀斩了你的色图。[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/cheems.jpg]"
    elseif (draw_arknights == 12) then
        local event = "多米诺好菜啊"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" ..
                "你铲着猫砂的时候，突然福临心至，脱口而出一句“多米诺好菜啊！”\n你环顾四周似乎没人发现，于是松了一口气。\n却没注意到自己的影子上开始缠绕着挥舞着不可名状的触手。"
    elseif (draw_arknights == 13) then
        local event = "镜花水月"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" ..
                "你重复的进行着铲屎的工作，这时，你突然闻到了一股奇特的气味，仿佛有湿滑的触手爬上了你的身体。\n“刀客塔～想我了吗？”\n一声呼唤在你耳边响起，你的意识逐渐远去。\n下一刻，你睁开了眼睛，周围的一切还是跟往常一样，这难道是梦吗？[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/shuiyue480.jpg]"
    elseif (draw_arknights == 14) then
        local event = "胡萝卜汁"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" .. event ..
                "】！\n" ..
                "你在猫砂里挖出一瓶橙色液体，上面贴着标签“Carrot Juice”，你决定埋深点。"
    elseif (draw_arknights == 15) then
        local event = "好呆比"
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 1)
        setUserToday(287887313, "today_draw_max", getUserToday(287887313, "today_draw_max", 0) + 1)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "呆比看你这么努力的铲屎，奖励了你一张寻访劵（不是从多米诺兜里拿的，对，不是）\n寻访券+1！\n多米诺寻访券-1！"
    elseif (draw_arknights == 16) then
        local event = "坏呆比"
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) + 1)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "你占据了呆比的厕所，呆比很生气，抢走了你一张寻访劵，骂骂咧咧的走远了\n寻访券-1！"
    elseif (draw_arknights == 17) then
        local event = "冥王星咖啡机"
        local coin = getUserConf(msg.fromQQ, "猫猫金币", 0)
        if (tonumber(coin) < 1) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "你挖出了一个长的像咖啡机的东西，你没有金币能够投进去，只能离开了。"
        elseif (coin == 1) then
            setUserConf(msg.fromQQ, "猫猫金币", 0)
            local draw_result = math.random(3)
            if (draw_result == 1) then
                return
                    "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                        event .. "】！\n" ..
                        "你挖出了一个长的像咖啡机的东西，你投进了自己的唯一一枚金币，咖啡机输出了一杯醇香的拿铁。"
            elseif (draw_result == 2) then
                local draw_result = math.random(3, 10)
                setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
                return
                    "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                        event .. "】！\n" ..
                        "你挖出了一个长的像咖啡机的东西，你投进了自己的唯一一枚金币，咖啡机输出了一个杯子，里面竟塞了一些寻访券！你数了数，一共有" ..
                        math.floor(draw_result) .. "张。"
            else
                local draw_result = math.random(3, 10)
                setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) + draw_result)
                return
                    "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                        event .. "】！\n" ..
                        "你挖出了一个长的像咖啡机的东西，你投进了自己的唯一一枚金币，咖啡机输出了一个杯子，里面竟塞着更多金币！你数了数，一共有" ..
                        math.floor(draw_result) .. "枚。"
            end
                else
            local coin = math.random(3)
            local draw_result = math.random(1, coin)
            setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) - coin)
            if (draw_result == 1) then
                return
                    "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                        event .. "】！\n" .. "你挖出了一个长的像咖啡机的东西，你朝里面投入了" ..
                        math.floor(coin) .. "枚金币，咖啡机输出了一杯醇香的拿铁。"
            elseif (draw_result == 2) then
                local draw_result = math.random(3, 10)
                setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
                return
                    "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                        event .. "】！\n" .. "你挖出了一个长的像咖啡机的东西，你朝里面投入了" ..
                        math.floor(coin) ..
                        "枚金币，咖啡机输出了一个杯子，里面竟塞了一些寻访券！你数了数，一共有" ..
                        math.floor(draw_result) .. "张。"
            else
                local draw_result = math.random(3, 10)
                setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) + draw_result)
                return
                    "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                        event .. "】！\n" .. "你挖出了一个长的像咖啡机的东西，你朝里面投入了" ..
                        math.floor(coin) ..
                        "枚金币，咖啡机输出了一个杯子，里面竟塞着一些金币！你数了数，一共有" ..
                        math.floor(draw_result) .. "枚。"
            end
        end
    else
        local event = "香蕉诅咒"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "你挖到了一个奇怪的东西，仔细一看，居然是一根香蕉，奇怪为什么猫砂盆里面会有这种东西。你决定把香蕉留在原地不去管它。"
        else
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到普通事件【" ..
                       event .. "】！\n" ..
                       "你挖到了一个奇怪的东西，仔细一看，居然是一根香蕉，奇怪为什么猫砂盆里面会有这种东西。你伸手想把香蕉拿出去，突然感到一阵恶寒，仿佛被什么东西缠上了。"
        end
    end
end

function draw_eventII(msg)
    local draw_arknights = math.random(21)
    local draw_result = math.random(0, 1)
    local today_ding = getUserToday(msg.fromQQ, "dingtimes", 0)
    if (draw_arknights == 1) then
        local event = "海盗猫猫"
        if (tonumber(getUserConf(msg.fromQQ, "猫猫金币", 0)) <= 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "在埋头你铲着猫砂的时候，突然窜过来一只戴着眼罩的黑色猫猫，他打量了几眼身无分文的你，叼走了你的铲子。"
        else
            local coin = getUserConf(msg.fromQQ, "猫猫金币", 0)
            setUserToday(msg.fromQQ, "today_draw_max",
                getUserToday(msg.fromQQ, "today_draw_max", 0) - getUserConf(msg.fromQQ, "猫猫金币", 0), 0)
            setUserConf(msg.fromQQ, "猫猫金币", 0)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "在埋头你铲着猫砂的时候，突然窜过来一只戴着眼罩的黑色海盗猫猫，他叼走了你浑身上下的" ..
                       math.floor(coin) .. "枚金币并留下了" .. math.floor(coin) .. "张寻访券。"
        end
    elseif (draw_arknights == 2) then
        local event = "猫砂空空"
        local coin = getUserConf(msg.fromQQ, "猫猫金币", 0)
        if (tonumber(coin) > 1) then
            setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) - 1)
            setUserToday(msg.fromQQ, "dingtimes", today_ding - 1)
            return
                "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                    event .. "】！\n" ..
                    "你来到呆比的猫砂盆前意外地发现猫砂用完了！\n没办法你找到咖啡机花费1枚猫猫金币，给呆比买了一袋新的猫砂。\n铲屎机会+1！\n你数了数口袋中的金币，现在还剩" ..
                    math.floor(getUserConf(msg.fromQQ, "猫猫金币",0)) .. "枚。"
        elseif (tonumber(getUserConf(msg.fromQQ, "猫猫金币", 0)) > 0) then
            setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) - 1)
            setUserToday(msg.fromQQ, "dingtimes", today_ding - 1)
            return
                "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                    event .. "】！\n" ..
                    "你来到呆比的猫砂盆前意外地发现猫砂用完了！\n没办法你找到咖啡机花费1枚猫猫金币，给呆比买了一袋新的猫砂。\n铲屎机会+1！\n你摸了摸口袋，里面已经没有金币剩下了。"
        elseif (tonumber(getUserToday(msg.fromQQ, "today_draw_max", 0)) > 0) then
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) + 1)
            setUserToday(msg.fromQQ, "dingtimes", today_ding - 1)
            return
                "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                    event .. "】！\n" ..
                    "你来到呆比的猫砂盆前意外地发现猫砂用完了！\n没办法你找到咖啡机花费1张寻访券，给呆比买了一份新的猫砂。\n铲屎机会+1！"
        else
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你来到呆比的猫砂盆前意外地发现猫砂用完了！\n你捏了捏空瘪的口袋，冷酷地离开了。"
        end
    elseif (draw_arknights == 3) then
        local event = "SCP-682"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "你正在铲着猫砂哼着歌的时候，一片阴影笼罩了你，回头一看居然是682大爷。它试着拍了拍你的头示意你好样的——\n啪叽，你死了。"
    elseif (draw_arknights == 4) then
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 2, 0)
        local event = "滴滴叭叭"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "你挖着猫砂的时候听到一阵音乐声传来，仔细一听“滴滴叭叭”连绵不断，原来是一只小海豹吹着萨克斯爬了过来，路过你的时候还送了你两张寻访券。[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/ddbb.jpg]"
    elseif (draw_arknights == 5) then
        local event = "蜜汁气味"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "猫砂堆内出现了一股蜜汁气味，熏得你头晕眼花。你被沉船之神诅咒了，幸运下降（↓）"
    elseif (draw_arknights == 6) then
        local event = "一起拉屎"
        if (math.random(100) >= 30) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "呆比亲切地呼唤了他的好朋友破空（划掉）Adobe来一起拉屎，盆子里的便便变成了两倍！你觉得好累，不铲了！[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/shit.jpg]"
        else
            local draw_result = math.random(2, 6)
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "呆比亲切地呼唤了他的好朋友破空（划掉）Adobe来一起拉屎，盆子里的便便变成了两倍！你尽心尽力地铲屎，挖出了" ..
                       math.floor(draw_result) ..
                       "张寻访券！[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/shit.jpg]"
        end
    elseif (draw_arknights == 7) then
        local event = "大盆重器"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "多米诺给呆比买了新的大号猫砂盆和新的铲子，但是铲子变大了好难握住呀，而且这个重心是不是不太对......觉得铲子太大，自己把握不住，便便都撒出来了！赶紧铲回去然后当做无事发生吧"
        else
            local draw_result = math.random(3, 5)
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "多米诺给呆比买了新的大号猫砂盆和新的铲子，但是铲子变大了好难握住呀，而且这个重心是不是不太对......你努力地挖出了" ..
                       math.floor(draw_result) .. "张寻访券!"
        end
    elseif (draw_arknights == 8) then
        local event = "薛定谔的意志"
        local draw_result = math.random(0, 3)
        if (draw_result == 3) then
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 3)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你在你的包里发现了既在你的包里又不在你的包里的三张寻访券，你伸手牢牢抓住了它们！"
        elseif (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你在你的包里发现了既在你的包里又不在你的包里的三张寻访券，当你伸手去抓它们的时候，量子态的它们消失了！"
        else
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你在你的包里发现了既在你的包里又不在你的包里的三张寻访券，当你伸手去拿它们的时候你抓到了其中的" ..
                       math.floor(draw_result) .. "张，另外的寻访券消失了！"
        end
    elseif (draw_arknights == 9) then
        local event = "几把猫很担心你"
        local draw_result = math.random(2)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "呆比今天不在家，你看见一只几把猫正非常担心地坐在猫砂盆旁边看着你，并指点你获得了" ..
                math.floor(draw_result) ..
                "张寻访券[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/jbcat.jpg]"
    elseif (draw_arknights == 10) then
        local event = "多洗爹"
        local draw_result = math.random(4)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "呆比去帮多多一起洗多米诺了，你可以安心大胆地多铲一会儿便便，并成功挖出了" ..
                math.floor(draw_result) ..
                "张寻访券！[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/dxd.jpg]"
    elseif (draw_arknights == 11) then
        local event = "呆吓唬"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "一只英国短毛蓝犬以风一样的速度跑了过去，它用惯性下楼梯，你被刮了一脸的猫砂。"
    elseif (draw_arknights == 12) then
        local event = "歹比！！！"
        local draw_arknights = math.random(3)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) + draw_arknights)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" .. event ..
                "】！\n" .. "一只海盗猫趁你专心铲屎偷走了你" .. math.floor(draw_arknights) ..
                "张寻访劵！首先排除是多多干的…"
    elseif (draw_arknights == 13) then
        local event = "吐不出笋的咖啡机"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "你在呆比的猫砂盆里挖到了一台咖啡机，这里怎么会有咖啡机呢?\n你这么想着，想要拿出来。\n此时咖啡机却突然不停重复着【输出失败，笋已经被夺完了】的声音陷入了猫砂深处。"
    elseif (draw_arknights == 14) then
        local event = "多米诺好强啊"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你在呆比的猫砂盆里挖到了一块石碑，你念出了上面的文字：多米诺好强啊\n这时，一只蠢蜥蜴探出脑袋说：“屁嘞！”"
        else
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你在呆比的猫砂盆里挖到了一块石碑，你念出了上面的文字：多米诺好强啊\n这时，一只海盗猫探出脑袋说：“对啊对啊！”"
        end
    elseif (draw_arknights == 15) then
        local event = "水母迷因"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "你看见猫砂盆中摆着一只水母，当你捏着它的头试着提起来时，它…它断了！！\n水母很生气：“兄弟啊，我想我们之前应该是不认识了吧，应该也是无冤无仇了厚，你非要过来摸我两下也就算了，你把我的头拔下来是要做什么，害得我刚出生就要去投胎！整天诶！”[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/jellymeme.jpg]"
    elseif (draw_arknights == 16) then
        local event = "三哼经"
        local draw_arknights = math.random(3)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) + draw_arknights)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" .. event ..
                "】！\n" .. "你在呆比的猫砂盆里挖出了一张圣人像，圣人像突然发出“哼，哼，哼”的声音，你被一股突然出现的恶臭熏昏了头。\n等你缓过来之后，发现身上少了" .. math.floor(draw_arknights) ..
                "张寻访劵。[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/senpai.gif]"
    elseif (draw_arknights == 17) then
        local event = "紫气东来"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "你正在铲屎，突然听见一声哀嚎，原来是旁边一位铲屎官拖着一溜紫光哭着跑远了，你叹了口气，摇摇头继续铲屎。[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/4.jpg]"
        elseif (draw_arknights == 18) then
        local event = "金色传说"
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" .. event ..
                "】！\n" ..
                "你正在铲屎，突然听见一声狂笑，原来是旁边一位铲屎官捧着一张六星在手舞足蹈，你吐了口痰，口中低声骂道：“草，有狗！”[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/6.jpg]"
    elseif (draw_arknights == 19) then
        local event = "野生的呆比！"
        if (draw_result == 0) then
            local draw_result = math.random(1, 5)
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_result)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你正铲着屎，忽然一只野生的呆比冲了过来，你进入了战斗！\n你战斗成功了，获得了" ..
                       math.floor(draw_result) .. "张寻访券!"
        else
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) + 1)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "你正铲着屎，忽然一只野生的呆比冲了过来，你进入了战斗！\n你战斗失败了，呆比抢走了你的1张寻访券!"
        end
    elseif (draw_arknights == 20) then
        local event = "上门服务的SCP-999"
        if (draw_result == 0) then
            local draw_result = math.random(1, 5)
            setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) - draw_result)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "一只黄色的软泥怪突然从猫砂里钻了出来，不由分说的就将你从脖子以下全部包裹住不停地挠痒，在你快要笑断气的时候被松开了，软泥怪也不见了，你检查了一下你的口袋，你失去了" ..
                       math.floor(draw_result) .. "枚金币的按摩费用。[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/999l.jpg]"
        else
            setUserConf(msg.fromQQ, "猫猫金币", getUserConf(msg.fromQQ, "猫猫金币", 0) - 1)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "一只黄色的软泥怪突然从猫砂里钻了出来，不由分说的就将你从脖子以下全部包裹住不停地挠痒，在你终于挣脱开时，软泥怪也不见了，你检查了一下你的口袋，你失去了1枚金币的按摩费用。[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/999w.jpg]"
        end
    else
        local event = "厚重猫砂"
        if (draw_result == 1) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "多米诺今天似乎往猫砂盆里加了太多刚买来的新款猫砂！猫砂好多，铲起来也好吃力！你奋力地铲啊铲，太难了！你感觉自己的铲子迷失在了无穷无尽的猫砂里，什么也没找到。"
        else
            local draw_arknights = math.random(3, 6)
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到稀有事件【" ..
                       event .. "】！\n" ..
                       "多米诺今天似乎往猫砂盆里加了太多刚买来的新款猫砂！猫砂好多，铲起来也好吃力！你奋力地铲啊铲，幸亏你经验丰富，你成功地在厚厚的猫砂里挖出了" ..
                       math.floor(draw_arknights) .. "张寻访券！"
        end
    end
end

function draw_eventIII(msg)
    local draw_arknights = math.random(9)
    local draw_result = math.random()
    local today_ding = getUserToday(msg.fromQQ, "dingtimes", 0)
    if (draw_arknights == 1) then
        local event = "脆性铲柄"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "你手里的铲柄变成了脆饼干！小心地一通操作后，你的铲子碎掉了！现在猫砂盆变得更脏了。"
        else
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 5)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "你手里的铲柄变成了脆饼干！小心地一通操作后，你用脆脆的铲子铲出了5张寻访券！"
        end
    elseif (draw_arknights == 2) then
        local event = "Rick Ashley"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "你刚靠近猫砂盆，突然一道白光闪过，你眼前出现了——[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/rickroll.gif]"
        else
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "你刚靠近猫砂盆，突然一道白光闪过，你眼前出现了——[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/rickroll.gif]"
        end
    elseif (draw_arknights == 3) then
        local event = "魅魔猫娘"
        local draw_arknights = math.random(6)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" .. event ..
                "】！\n" ..
                "你挖着猫砂突然感到一阵恍惚，突然出现在一张大床上，眼前出现了一个自称木各曼的猫娘魅魔，ta在你身上一番索取后给了你" ..
                math.floor(draw_arknights) .. "张寻访券作为回报。"
    elseif (draw_arknights == 4) then
        local event = "流沙猫砂"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "在某一次下铲之后你的铲子好像被吸住了，猫砂盆里的猫砂似乎形成了类似沙漠里的流沙陷阱，你用尽全身力气，却还是不敌吸力，铲子被吸走了。"
        else
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 4)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "在某一次下铲之后你的铲子好像被吸住了，猫砂盆里的猫砂似乎形成了类似沙漠里的流沙陷阱，你用尽全身力气，终于拔出了铲子连带着拔出了4张寻访券。"
        end
    elseif (draw_arknights == 5) then
        local event = "砂中宝藏"
        local draw_arknights = math.random(5, 10)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" .. event ..
                "】！\n" ..
                "你挖呀挖，挖呀挖，挖到了——海盗猫猫偷偷藏在呆比这里的大宝箱！你打开宝箱，哇，里面是" ..
                math.floor(draw_arknights) .. "张寻访卷！"
    elseif (draw_arknights == 6) then
        local event = "路易十六"
        local draw_arknights = math.random(10, 20)
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights)
        setUserToday(msg.fromQQ, "dingtimes", 10)
        return
            "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" .. event ..
                "】！\n" ..
                "你看着手中的一溜紫光欲哭无泪，此时一个手握六星的法国皇帝路过，你怒从心中起恶向胆边生，抄起手边的铲铲冲了过去，口中大喊到：“欧狗受死！！”\n你从他的手中夺得了" ..
                math.floor(draw_arknights) .. "张寻访卷，但也因此被关进了监狱——\n今天你不能再铲屎了！"
    elseif (draw_arknights == 7) then
        local event = "多家福"
        local draw_arknights = math.random(2)
        if (draw_arknights == 1) then
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 4)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "章鱼红肠邀请你给他们拍全家福，他的家人有一只蠢蜥蜴，一只海盗猫，一只英国短毛蓝犬。在你拍完照后，章鱼红肠对你的摄影技术非常满意，并赠予了你4张寻访劵！[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/family.jpg]"
        else
            setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) + 4)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "章鱼红肠邀请你给他们拍全家福，他的家人有一只蠢蜥蜴，一只海盗猫，一只英国短毛蓝犬。在你拍完照后，章鱼红肠对你的摄影技术非常不满意，并从你手里抢走了4张寻访劵！[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/family1.jpg]"
        end
    elseif (draw_arknights == 8) then
        local event = "您找到了您到了您找您禁止存在您是找到存在不合理的您"
        local draw_arknights = math.random(2)
        if (draw_arknights == 1) then
            setUserToday(msg.fromQQ, "today_draw_max", 99999)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "您在猫砂盆里找到了禁止的不合理的不允许未经授权的错误的不合理的您的的猫砂盆的正确的猫砂盆的您的存在的意义的不合理的猫砂盆的猫砂盆的您的您的猫砂的正确的香蕉的正确的香蕉的正确的您禁止离开的您不合理的您禁止存在的您错误的您被否认的您未经授权的您的您的您的您的您的您的您的您的您的您的您的您的您的您的存在未经授权，您禁止离开\n\n\n\n\n\n看看您的铲屎统计吧。"
        else
            setUserToday(msg.fromQQ, "today_draw_max", -99999)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "您在猫砂盆里找到了禁止的不合理的不允许未经授权的错误的不合理的您的的猫砂盆的正确的猫砂盆的您的存在的意义的不合理的猫砂盆的猫砂盆的您的您的猫砂的正确的香蕉的正确的香蕉的正确的您禁止离开的您不合理的您禁止存在的您错误的您被否认的您未经授权的您的您的您的您的您的您的您的您的您的您的您的您的您的您的存在未经授权，您禁止离开\n\n\n\n\n\n看看您的铲屎统计吧。"
        end
    else
        local event = "真假猫砂"
        if (draw_result == 0) then
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "今天似乎有点不一样，在你面前出现了两个猫砂盆，显然调皮的呆比想让你猜猜看哪一个被它藏了惊喜，一番思索后你选择了其中一个，然而找了很久却一无所获。"
        else
            local draw_arknights = math.random(3)
            local draw2_arknights = math.random(3)
            setUserToday(msg.fromQQ, "today_draw_max",
                getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights - draw2_arknights)
            return "{nick}第" .. math.floor(today_ding) .. "次将头探向猫砂盆……\n遇到特殊事件【" ..
                       event .. "】！\n" ..
                       "今天似乎有点不一样，在你面前出现了两个猫砂盆，显然调皮的呆比想让你猜猜看哪一个被它藏了惊喜，一番思索后你选择了其中一个，里面居然有" ..
                       math.floor(draw_arknights + draw2_arknights) .. "张寻访券。"
        end
    end
end

msg_order["铲屎统计"] = "dingdata"
