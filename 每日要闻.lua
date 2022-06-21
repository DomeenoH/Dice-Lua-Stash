--问安样例脚本
--使用《署名—非商业性使用—相同方式共享 4.0 协议国际版》（CC BY-NC-SA 4.0）进行授权https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.zh-Hans
--加载后请手动设置定时任务
--作者:安研色Shiki
task_call = {
    good_morning="good_morning",
}
notice_head = ".send notice 6 "
function table_draw(tab)
    if(#tab==0)then return "" end
    return tab[ranint(1,#tab)]
end
morning_word = {
    "早上好呀铲屎官！起床了嘛？和多多一起看看今天发生的重要事情吧！",
}
morning_news = {
    "[CQ:image,url=https://api.emoao.com/api/60s]",
}
function good_morning()
    eventMsg(notice_head..table_draw(morning_word), 0, getDiceQQ())
    eventMsg(notice_head..table_draw(morning_news), 0, getDiceQQ())
end

function printChat(msg)
    if(msg.fromGroup=="0")then
        return "QQ "..msg.fromQQ
    else
        return "group "..msg.fromGroup
    end
end

msg_order = {}
function book_alarm_call(msg)
    eventMsg(".admin notice "..printChat(msg).." +6", 0, getDiceQQ())
    return "你成功在这里订阅{self}每天早上八点半的每日要闻啦！"
end
function unbook_alarm_call(msg)
    eventMsg(".admin notice "..printChat(msg).." -6", 0, getDiceQQ())
    return "你成功在这里退订{self}每天早上八点半的每日要闻咯！"
end
msg_order["订阅每日要闻"]="book_alarm_call"
msg_order["退订每日要闻"]="unbook_alarm_call"
