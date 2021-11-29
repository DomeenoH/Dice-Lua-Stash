--[[
作者：白咕咕
联系方式：2432115441
交流群：822417015
版本：v1.1.1
说明：本Lua依赖于Api(http://api.baimianxiao.cn/mrfz/api.php)运行，Api文档http://bbs.baimianxiao.cn/d/26-api/2
限于服务器性能，使用人数过多可能会出现延迟

鸣谢
夙源提供的服务器支持
SkyLand·苍穹共同编写Api
]]

--以下为自定义部分

draw_msg="方舟十连"
--自定义抽卡指令

draw_state="寻访状态"

draw_everyday_max=2
--每日最大抽卡次数

msg_everyday_max="今天的十连寻访券都用光啦！给{self}[铲屎]有机会获得更多寻访券喔~"
--超过最大抽卡次数回复

master_qq="287887313"
--设置masterqq

kj_kind=2
--框架，先驱为1，Mirai为2

--以上为自定义部分
msg_order={}
function arknights_draw_main(msg)
  if(msg.fromMsg==draw_msg)then
   if(getUserToday(msg.fromQQ, "today_draw_max", 0) == draw_everyday_max)then
      if(kj_kind==1)then
         kj_pic="[pic="
      else
         kj_pic="[CQ:image,url="
      end
      setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0)+1)
      return kj_pic.."http://api.dominoh.com/arknights/api.php]{nick}今天的最后1发！给{self}[铲屎]有机会获得更多寻访券喔~"
      elseif(getUserToday(msg.fromQQ, "today_draw_max", 0)<draw_everyday_max)then
      if(kj_kind==1)then
         kj_pic="[pic="
      else
         kj_pic="[CQ:image,url="
      end
      setUserToday(msg.fromQQ, "today_draw_max", getUserToday(msg.fromQQ, "today_draw_max", 0)+1)
      return kj_pic.."http://api.dominoh.com/arknights/api.php]{nick}今天还能再抽"..math.floor(1 + draw_everyday_max - getUserToday(msg.fromQQ, "today_draw_max", 0)).."发！"
    else
      return "{nick}"..msg_everyday_max
    end
  else
   return ""
  end
end
function arknights_draw_state(msg)
   if(msg.fromQQ==master_qq)then
      return "管理员权限："..master_qq.."\n版本：v1.1.2\n每日最大寻访次数："..draw_everyday_max.."\n寻访指令："..draw_msg
   else
      return "你不是寻访管理员"
   end
end

function arknights_draw_master(msg)
   if(msg.fromQQ==master_qq)then
      local user_qq=string.sub(msg.fromMsg,7,-1)
      setUserToday(user_qq, "today_draw_max", 0)
      return "多米诺给[CQ:at,qq="..user_qq.."]("..user_qq..")又发了三张十连寻访券！"
   else
      return ""
   end
end
msg_order[draw_msg]="arknights_draw_main"
msg_order["重置"]="arknights_draw_master"
msg_order[draw_state]="arknights_draw_state"