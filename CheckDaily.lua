--.Ding打卡脚本~给你的骰娘装上这个，就可以实现每日打卡功能了！
--.Ding打卡 .DingData查看打卡数据
--作者 MSCxar0293
--版本 v1.0
--更新日期 20210711

msg_order = {}

function checkDaily(msg)
local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)--取总打卡次数
local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)--取连续打卡天数
local userCheckOne = getUserConf(msg.fromQQ,"打卡时间",0)--取上次打卡时间
local date=os.date("%j");--系统时间,一年中的XXX天

--判断是否断签
local boolDuanQian = 0
if(date == 1)then--如果今天是一年中的第一天
    if(math.fmod(os.date("%Y") - 1,4) == 0)then--判断去年是不是闰年
        boolDuanQian = date + 366 - userCheckOne
    else
        boolDuanQian = date + 365 - userCheckOne
    end
else
    boolDuanQian = date - userCheckOne
end

--限制今日打卡次数为1
local bonus_arknights = math.random(100)
local ding_limit = 1
local today_ding = getUserToday(msg.fromQQ,"dingtimes",0)--判断今日是否打卡
    if(today_ding>=ding_limit)then
      if(bonus_arknights >= 5)then
        return "{nick}在{self}空荡荡的猫砂盆里奋力翻找着什么，但一无所获。\n今天是累计第"..math.floor(userTotalCheck).."天铲屎啦！\n连续铲屎"..math.floor(userComboCheck).."天了喵~"
      else
        setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
        return "{nick}又一次翻找着{self}的猫砂盆，从里面找到了"..math.floor(bonus_arknights).."张十连寻访券！\n今天是累计第"..math.floor(userTotalCheck).."天铲屎啦！\n连续铲屎"..math.floor(userComboCheck).."天了喵~"
        --测试信息：\nuserTotalCheck="..math.floor(userTotalCheck).."\nuserComboCheck="..math.floor(userComboCheck).."\ndate="..date.."\nuserCheckOne="..userCheckOne.."\nboolDuanQian="..boolDuanQian..""
      end
      else
        today_ding = today_ding + 1
        setUserToday(msg.fromQQ, "dingtimes", today_ding)
    end
   



if(userTotalCheck == 0) then
--第一次打卡者的特殊处理
 setUserConf(msg.fromQQ, "打卡时间", date)
 setUserConf(msg.fromQQ, "连续打卡", 1)--设置连续打卡天数为1
 setUserConf(msg.fromQQ, "总打卡次数", 1)--设置总打卡天数为1
 local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)
 local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)
 local bonus_arknights = math.random(5)
 setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
    return "{nick}今日铲屎成功~你在猫砂盆中翻出了"..math.floor(bonus_arknights).."张十连寻访券！\n您已累计铲屎"..math.floor(userTotalCheck).."天！\n连续铲屎"..math.floor(userComboCheck).."天~\n明天也不要忘了铲屎喵——"

 else if(boolDuanQian ~= 1)then
--连续打卡中断
  setUserConf(msg.fromQQ, "打卡时间", date)
  setUserConf(msg.fromQQ,"连续打卡",1)--设置连续打卡天数为1
  setUserConf(msg.fromQQ, "总打卡次数", getUserConf(msg.fromQQ, "总打卡次数", 0)+1)--总打卡天数+1
  local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)
  local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)
  local bonus_arknights = math.random(5)
  setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
    return "{nick}今日铲屎成功~你在猫砂盆中翻出了"..math.floor(bonus_arknights).."张十连寻访券！\n您已累计铲屎"..math.floor(userTotalCheck).."天！\n连续铲屎"..math.floor(userComboCheck).."天~\n明天也不要忘了铲屎喵——"

  else
--正常连续打卡的情况
   setUserConf(msg.fromQQ, "打卡时间", date)
   setUserConf(msg.fromQQ, "连续打卡", getUserConf(msg.fromQQ, "连续打卡", 0)+1)
   setUserConf(msg.fromQQ, "总打卡次数", getUserConf(msg.fromQQ, "总打卡次数", 0)+1)
   local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)
   local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)
   local bonus_arknights = math.random(5)
   setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
    return "{nick}今日铲屎成功~你在猫砂盆中翻出了"..math.floor(bonus_arknights).."张十连寻访券！\n您已累计铲屎"..math.floor(userTotalCheck).."天！\n连续铲屎"..math.floor(userComboCheck).."天~\n明天也不要忘了铲屎喵——"

  end
 end
end--function的end

msg_order["铲屎"] = "checkDaily"

--以下为查询打卡信息
function dingdata(msg)
local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)
local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)
local userCheckOne = getUserConf(msg.fromQQ,"打卡时间",0)
  return "{nick}已经累计铲屎"..math.floor(userTotalCheck).."天，连续铲屎"..math.floor(userComboCheck).."天了喵——"
end

msg_order["铲屎统计"] = "dingdata"