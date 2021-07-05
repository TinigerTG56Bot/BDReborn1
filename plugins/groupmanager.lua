--begin groupmanager by @BeyondTeam :)
--This Is Self Bot Based On BDReborn :D
local function action_by_reply(arg, data)
   local cmd = arg.cmd
   local msg = arg.msg
  if data.sender_user_id then
   if cmd == "silent" then
		if is_silented_user(data.chat_id, data.sender_user_id) then
			return edit_msg(data.chat_id, msg.id, "`["..data.sender_user_id.."]` _is already_ *silented.*", "md")
		end
			silent_user(data.chat_id, data.sender_user_id)
		return edit_msg(data.chat_id, msg.id, "`["..data.sender_user_id.."]` _added to_ *silent users list.*", "md")
   end
   if cmd == "unsilent" then
		if is_silented_user(data.chat_id, data.sender_user_id) then
			unsilent_user(data.chat_id, data.sender_user_id)
			return edit_msg(data.chat_id, msg.id, "`["..data.sender_user_id.."]` _removed from_ *silent users list.*", "md")
else
			return edit_msg(data.chat_id, msg.id, "`["..data.sender_user_id.."]` _is not_ *silented.*", "md")
		end
   end
   if cmd == "inv" then
 invite_user(data.sender_user_id, data.chat_id)
   end
   if cmd == "kick" then
 kick_user(data.sender_user_id, data.chat_id)
   end
  if cmd == "delall" then
tdbot.deleteMessagesFromUser(data.chat_id, data.sender_user_id, dl_cb, nil)
   end
   if cmd == "id" then
    edit_msg(data.chat_id, msg.id, "`"..data.sender_user_id.."`", "md")
   end
else
  return edit_msg(data.chat_id, msg.id, "*User not founded*", "md")
     end
  end

local function action_by_username(arg, data)
   local cmd = arg.cmd
   local msg = arg.msg
  if data.id then
   if cmd == "silent" then
		if is_silented_user(arg.chat_id, data.id) then
			return edit_msg(arg.chat_id, msg.id, "`["..data.id.."]` _is already_ *silented.*", "md")
		end
			silent_user(arg.chat_id, data.id)
		return edit_msg(arg.chat_id, msg.id, "`["..data.id.."]` _added to_ *silent users list.*", "md")
   end
   if cmd == "unsilent" then
		if is_silented_user(arg.chat_id, data.id) then
			unsilent_user(arg.chat_id, data.id)
			return edit_msg(arg.chat_id, msg.id, "`["..data.id.."]` _removed from_ *silent users list.*", "md")
else
			return edit_msg(arg.chat_id, msg.id, "`["..data.id.."]` _is not_ *silented.*", "md")
		end
   end
   if cmd == "inv" then
 invite_user(data.id, arg.chat_id)
   end
   if cmd == "kick" then
 kick_user(data.id, arg.chat_id)
   end
   if cmd == "delall" then
tdbot.deleteMessagesFromUser(arg.chat_id, data.id, dl_cb, nil)
   end
   if cmd == "id" then
     edit_msg(arg.chat_id, msg.id, "`"..data.id.."`", "md")
   end
else
  return edit_msg(arg.chat_id, msg.id, "*User not founded*", "md")
     end
  end

local function run(msg, matches)
   local chat = msg.to.id
   local user = msg.from.id
  if is_sudo(msg) then
if matches[1] == "gpid" then
if not matches[2] and not msg.reply_id then
return edit_msg(msg.to.id, msg.id, "*Group ID :* _"..msg.to.id.."_", "md")
  end
end
if matches[1] == "id" then
if not matches[2] and msg.reply_id then
    tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="id",msg=msg})
  end
if matches[2] and not msg.reply_id then
   tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="id",msg=msg})
      end
   end
 if matches[1] == "kick" then
    del_msg(msg.to.id, msg.id)
if not matches[2] and msg.reply_id then
    tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_to_message_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="kick",msg=msg})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
   kick_user(matches[2], msg.to.id)
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="kick",msg=msg})
         end
      end
 if matches[1] == "silent" then
if not matches[2] and msg.reply_id then
    tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_to_message_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="silent",msg=msg})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
		if is_silented_user(msg.to.id, tonumber(matches[2])) then
			return edit_msg(msg.to.id, msg.id, "`["..matches[2].."]` _is already_ *silented.*", "md")
		end
			silent_user(msg.to.id, tonumber(matches[2]))
		return edit_msg(msg.to.id, msg.id, "`["..matches[2].."]` _added to_ *silent users list.*", "md")
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="silent",msg=msg})
         end
      end
 if matches[1] == "unsilent" then
if not matches[2] and msg.reply_id then
    tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_to_message_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unsilent",msg=msg})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
   		if is_silented_user(msg.to.id, tonumber(matches[2])) then
			unsilent_user(msg.to.id, tonumber(matches[2]))
			return edit_msg(msg.to.id, msg.id, "`["..matches[2].."]` _removed from_ *silent users list.*", "md")
else
			return edit_msg(msg.to.id, msg.id, "`["..matches[2].."]` _is not_ *silented.*", "md")
		end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unsilent",msg=msg})
         end
      end
if matches[1] == "inv" then
    del_msg(msg.to.id, msg.id)
if not matches[2] and msg.reply_id then
    tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="inv",msg=msg})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
   invite_user(matches[2], msg.to.id)
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="inv",msg=msg})
         end
      end
 if matches[1] == "delall" and msg.to.type == "channel" then
    del_msg(msg.to.id, msg.id)
if not matches[2] and msg.reply_id then
    tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="delall",msg=msg})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
tdbot.deleteMessagesFromUser(msg.to.id, matches[2], dl_cb, nil)
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="delall",msg=msg})
         end
      end
if matches[1] == 'setlink' and is_sudo(msg) then
            hash = 'gplink:'..chat
            redis:set(hash, matches[2])
    return edit_msg(msg.to.id, msg.id, "*Newlink* _has been set_", "md")
  end
    if matches[1] == 'link' and is_sudo(msg) then
            hash = 'gplink:'..chat
            local linkgp = redis:get(hash)
            if not linkgp then
     return edit_msg(msg.to.id, msg.id, "_First set a link with_ *using ➣ /setlink link*", "md")
         end
        tdbot.sendMessage(user, "", 1, "<b>Group Link :</b>\n"..linkgp, 1, 'html')
            return edit_msg(msg.to.id, msg.id, "_Link was send in your private message_", "md")
     end
if matches[1] == "setname" and matches[2] then
    del_msg(msg.to.id, msg.id)
local gp_name = string.gsub(matches[2], "_","")
tdbot.changeChatTitle(chat, gp_name, dl_cb, nil)
end
if matches[1] == 'tosuper' then
local id = msg.to.id
     if msg.to.type == "channel" then
   return edit_msg(msg.to.id, msg.id, "_This Chat Is Already SuperGroup...!_", "md")
     else
   tdbot.migrateGroupChatToChannelChat(id, dl_cb, nil)
    return edit_msg(msg.to.id, msg.id, '_Group Has Been Changed To SuperGroup!_', "md")
   end
end
     if msg.to.type == "channel" then
    if matches[1] == "mute" then
    if matches[2] == "all" then
                    local hash = 'mute_gp:'..chat
                    if redis:get(hash) then
                    return edit_msg(msg.to.id, msg.id, "*Mute All* _Is Already_ *Enabled*", "md")
                else
                    redis:set(hash, true)
                    return edit_msg(msg.to.id, msg.id, "*Mute All* _Has Been_ *Enabled*", "md")
                     end
                  end
    elseif matches[1] == "unmute" then
      if matches[2] == 'all' then
                    local hash = 'mute_gp:'..chat
                    if not redis:get(hash) then
                    return edit_msg(msg.to.id, msg.id, "*Mute All* _Is Not_ *Enabled*", "md")
                else
                    redis:del(hash)
                    return edit_msg(msg.to.id, msg.id, "*Mute All* _Has Been_ *Disabled*", "md")
                   end
					   end
             end
			if matches[1] == 'clean' and matches[2] == 'silentlist' then
			local silents = "silent_user:"..msg.to.id
					redis:del(silents)
				return edit_msg(msg.to.id, msg.id, "*Silent Users List* _has been_ *cleaned*", "md")
      end
  if matches[1] == "setdes" and matches[2] then
   tdbot.changeChannelAbout(chat, matches[2], dl_cb, nil)
    return edit_msg(msg.to.id, msg.id, "*Description* _has been set_", "md")
  end
  if matches[1] == "silentlist" then
    return edit_msg(msg.to.id, msg.id, silented_user_list(msg.to.id), "md")
  end
if matches[1] == "del" then
   del_msg(msg.to.id, msg.reply_id)
del_msg(msg.to.id, msg.id)
end
if matches[1]:lower() == 'reset' and matches[2] == 'msgs' then
   if not is_sudo(msg) then
    return
   end
  local hash = redis:key('msgs:'*':*')
  for i=1,#hash do
    redis:del(hash[i])
   end
     return edit_msg(msg.to.id, msg.id, "*Done*", "md")
  end
if matches[1] == "pin" and msg.reply_id then
tdbot.pinChannelMessage(msg.to.id, msg.reply_id, 1, dl_cb, nil)
return edit_msg(msg.to.id, msg.id, "*Message Has Been Pinned*", "md")
end
if matches[1] == 'unpin' then
tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
return edit_msg(msg.to.id, msg.id, "*Pin message has been unpinned*", "md")
         end
      end
   end
end
return { 
patterns = { 
"^[!/#](pin)$", 
"^[!/#](unpin)$",
"^[!/#](inv)$", 
"^[!/#](kick)$",
"^[!/#](inv) (.*)$", 
"^[!/#](kick) (.*)$",
"^[!/#](id)$",
"^[!/#](id) (.*)$", 
"^[!/#](whois) (%d+)$", 
"^[!/#](delall)$",
"^[!/#](delall) (.*)$", 
"^[!/#](gpid)$",
"^[!/#](del)$", 
"^[!/#](tosuper)$", 
"^[!/#](setname) (.*)$",
"^[!/#](link)$",
"^[!/#](setlink) (.*)$", 
"^[!/#](setdes) (.*)$",
"^[!/#](import) (.*)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
"^[!/#](silentlist)$",
"^[!/#](silent)$",
"^[!/#](silent) (.*)$",
"^[!/#](unsilent)$",
"^[!/#](unsilent) (.*)$",
"^[!/#](clean) (.*)$",
"^[!/#](reset) (msgs)$",
}, 
run = run 
}

