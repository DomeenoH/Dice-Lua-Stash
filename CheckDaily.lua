--.Ding打卡脚本~给你的骰娘装上这个，就可以实现每日打卡功能了！
--.Ding打卡 .DingData查看打卡数据
--作者 MSCxar0293
--版本 v1.0
--更新日期 20210711
--多米诺修改 20211129

msg_order = {}

function checkDaily(msg)
local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)--取总打卡次数
local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)--取连续打卡天数
local userCheckOne = getUserConf(msg.fromQQ,"打卡时间",0)--取上次打卡时间
local date=os.date("%j");--系统时间,一年中的XXX天
local bonus_arknights = math.random(100)

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

--限制今日重复打卡次数为5
local ding_limit = 1
local ding_ddl = 5
local today_ding = getUserToday(msg.fromQQ,"dingtimes",0)--判断今日是否打卡

if(today_ding>=ding_ddl)then
  return "{nick}在{self}空荡荡的猫砂盆里徒劳地翻找着什么。"
elseif(today_ding>=ding_limit)then
    if(bonus_arknights <= 30)then
      today_ding = today_ding + 1
      setUserToday(msg.fromQQ, "dingtimes", today_ding)
      return "{nick}第"..math.floor(today_ding).."次在{self}的猫砂盆里奋力翻找着什么，但一无所获。"
    elseif(bonus_arknights <= 70)then
      today_ding = today_ding + 1
      setUserToday(msg.fromQQ, "dingtimes", today_ding)
      --local draw_arknights = math.random(5)
      --local draw_result = math.random()
      return draw_eventI(msg)
    elseif(bonus_arknights <= 90)then
      today_ding = today_ding + 1
      setUserToday(msg.fromQQ, "dingtimes", today_ding)
      --local draw_arknights = math.random(2)
      --local draw_result = math.random()
      return draw_eventII(msg)
    elseif(bonus_arknights <= 100)then
      today_ding = today_ding + 1
      setUserToday(msg.fromQQ, "dingtimes", today_ding)
      --local draw_arknights = math.random(3)
      --local draw_result = math.random()
      return draw_eventIII(msg)
    else
      return ""
      --setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
      --return "{nick}第"..math.floor(today_ding).."次翻找着{self}的猫砂盆，从里面找到了"..math.floor(bonus_arknights).."张十连寻访券！"
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
    return "{nick}今日铲屎成功！\n你在猫砂盆中翻出了"..math.floor(bonus_arknights).."张十连寻访券！\n您已累计铲屎"..math.floor(userTotalCheck).."天！\n连续铲屎"..math.floor(userComboCheck).."天~"

 else if(boolDuanQian ~= 1)then
--连续打卡中断
  setUserConf(msg.fromQQ, "打卡时间", date)
  setUserConf(msg.fromQQ,"连续打卡",1)--设置连续打卡天数为1
  setUserConf(msg.fromQQ, "总打卡次数", getUserConf(msg.fromQQ, "总打卡次数", 0)+1)--总打卡天数+1
  local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)
  local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)
  local bonus_arknights = math.random(5)
  setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
    return "{nick}今日铲屎成功！\n你在猫砂盆中翻出了"..math.floor(bonus_arknights).."张十连寻访券！\n您已累计铲屎"..math.floor(userTotalCheck).."天！\n连续铲屎"..math.floor(userComboCheck).."天~"

  else
--正常连续打卡的情况
   setUserConf(msg.fromQQ, "打卡时间", date)
   setUserConf(msg.fromQQ, "连续打卡", getUserConf(msg.fromQQ, "连续打卡", 0)+1)
   setUserConf(msg.fromQQ, "总打卡次数", getUserConf(msg.fromQQ, "总打卡次数", 0)+1)
   local userTotalCheck = getUserConf(msg.fromQQ,"总打卡次数",0)
   local userComboCheck = getUserConf(msg.fromQQ,"连续打卡",0)
   local bonus_arknights = math.random(5)
   setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - bonus_arknights)
    return "{nick}今日铲屎成功！\n你在猫砂盆中翻出了"..math.floor(bonus_arknights).."张十连寻访券！\n您已累计铲屎"..math.floor(userTotalCheck).."天！\n连续铲屎"..math.floor(userComboCheck).."天~"

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


--以下为事件
function draw_eventI(msg)
  local draw_arknights = math.random(5)
  local draw_result = math.random()
  local today_ding = getUserToday(msg.fromQQ,"dingtimes",0)
  if(draw_arknights == 1)then
    local event="大号猫砂盆"
    if(draw_result == 0)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."呆比换了大号猫砂盆，你在猫砂盆里刨了半天，什么也没有找到。"
    elseif(draw_result == 1)then
      setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 1)
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."呆比换了大号猫砂盆，你在猫砂盆里刨了半天，只找到1张寻访券——"
    else
      end
  elseif(draw_arknights == 2)then
    local event="黄金咖啡"
    if(draw_result == 0)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你挖到了一坨散发出浓郁咖啡香气的玩意，你决定不深究它是什么"
    else
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你挖到了一坨散发出浓郁咖啡香气的玩意，你决定不深究它是什么"
      end
  elseif(draw_arknights == 3)then
    local event="埋山山"
    if(draw_result == 0)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你越挖越深，突然你挖到了一只被大家埋起来的山山，你决定装作没看见把山山埋回去。"
    else
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你越挖越深，突然你挖到了一只被大家埋起来的山山，你决定挖深点埋掉山山免得被其他人挖出来。"
      end
  elseif(draw_arknights == 4)then
      local event="神秘金币"
      if(draw_result == 0)then
        return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你挖到了一枚印着猫猫图案的金币。"
      else
        return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你挖到了一枚印着猫猫图案的金币。"
      end
  else
      local event="香蕉诅咒"
      if(draw_result == 0)then
        return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你挖到了一个奇怪的东西，仔细一看，居然是一根香蕉，奇怪为什么猫砂盆里面会有这种东西。你决定把香蕉留在原地不去管它。"
      else
        return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到I级事件【"..event.."】！\n".."你挖到了一个奇怪的东西，仔细一看，居然是一根香蕉，奇怪为什么猫砂盆里面会有这种东西。你伸手想把香蕉拿出去，突然感到一阵恶寒，仿佛被什么东西缠上了。"
      end
  end
end

function draw_eventII(msg)
  local draw_arknights = math.random(2)
  local draw_result = math.random(0,1)
  local today_ding = getUserToday(msg.fromQQ,"dingtimes",0)
  if(draw_arknights == 1)then
    local event="海盗猫猫"
    if(draw_result == 0)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到II级事件【"..event.."】！\n".."在埋头你铲着猫砂的时候，突然窜过来一只戴着眼罩的黑色猫猫，他打量了你几眼，叼走了你的铲子。"
    else
      local draw_arknights = math.random(3)
      setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights)
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到II级事件【"..event.."】！\n".."在埋头你铲着猫砂的时候，突然窜过来一只戴着眼罩的黑色猫猫，他叼走了你身上的金币并留下了"..math.floor(draw_arknights).."张寻访券。"
    end
  else
    local event="厚重猫砂"
    if(draw_result == 1)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到II级事件【"..event.."】！\n".."多米诺今天似乎往猫砂盆里加了太多刚买来的新款猫砂！猫砂好多，铲起来也好吃力！你奋力地铲啊铲，太难了！你感觉自己的铲子迷失在了无穷无尽的猫砂里，什么也没找到。"
    else
    local draw_arknights = math.random(3, 6)
    setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights)
    return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到II级事件【"..event.."】！\n".."多米诺今天似乎往猫砂盆里加了太多刚买来的新款猫砂！猫砂好多，铲起来也好吃力！你奋力地铲啊铲，幸亏你经验丰富，你成功地在厚厚地猫砂里挖出了"..math.floor(draw_arknights).."张寻访卷！"
    end
  end
end
  
function draw_eventIII(msg)
  local draw_arknights = math.random(3)
  local draw_result = math.random()
  local today_ding = getUserToday(msg.fromQQ,"dingtimes",0)
  if(draw_arknights == 1)then
    local event="脆性铲柄"
    if(draw_result == 0)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到III级事件【"..event.."】！\n".."你手里的铲柄变成了脆饼干！小心地一通操作后，你的铲子碎掉了！现在猫砂盆变得更脏了。"
    else
      setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - 5)
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到III级事件【"..event.."】！\n".."你手里的铲柄变成了脆饼干！小心地一通操作后，你用脆脆的铲子铲出了5张寻访券！"
      end
  elseif(draw_arknights == 2)then
    local event="Rick Ashley"
    if(draw_result == 0)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到III级事件【"..event.."】！\n".."你刚靠近猫砂盆，突然一道白光闪过，你眼前出现了——[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/rickroll.gif]"
    else
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到III级事件【"..event.."】！\n".."你刚靠近猫砂盆，突然一道白光闪过，你眼前出现了——[CQ:image,url=https://cdn.jsdelivr.net/gh/DomeenoH/pics@master/rickroll.gif]"
    end
  else
    local event="真假猫砂"
    if(draw_result == 0)then
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到III级事件【"..event.."】！\n".."今天似乎有点不一样，在你面前出现了两个猫砂盆，显然调皮的呆比想让你猜猜看哪一个被它藏了惊喜，一番思索后你选择了其中一个，然而找了很久却一无所获。"
    else
      local draw_arknights = math.random(3)
      local draw2_arknights = math.random(3)
      setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0) - draw_arknights - draw2_arknights)
      return "{nick}第"..math.floor(today_ding).."次将头伸向猫砂盆……\n遇到III级事件【"..event.."】！\n".."今天似乎有点不一样，在你面前出现了两个猫砂盆，显然调皮的呆比想让你猜猜看哪一个被它藏了惊喜，一番思索后你选择了其中一个，里面居然有"..math.floor(draw_arknights + draw2_arknights).."张寻访券。"
    end
  end
end

msg_order["铲屎统计"] = "dingdata"