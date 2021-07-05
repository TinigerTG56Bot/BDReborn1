do
--Begin Fun.lua By @BeyondTeam
--Special Thx To @To0fan
--------------------------------

local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
--------------------------------
local api_key = nil
local base_api = "https://maps.googleapis.com/maps/api"
--------------------------------
local function get_latlong(area)
	local api      = base_api .. "/geocode/json?"
	local parameters = "address=".. (URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters .. "&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
	local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
		return lat,lng,acc,types
	end
end
--------------------------------
local function get_staticmap(area)
	local api        = base_api .. "/staticmap?"
	local lat,lng,acc,types = get_latlong(area)
	local scale = types[1]
	if scale == "locality" then
		zoom=8
	elseif scale == "country" then 
		zoom=4
	else 
		zoom = 13 
	end
	local parameters =
		"size=600x300" ..
		"&zoom="  .. zoom ..
		"&center=" .. URL.escape(area) ..
		"&markers=color:red"..URL.escape("|"..area)
	if api_key ~= nil and api_key ~= "" then
		parameters = parameters .. "&key="..api_key
	end
	return lat, lng, api..parameters
end
--------------------------------
local function get_weather(location)
	print("Finding weather in ", location)
	local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	local url = BASE_URL
	url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
	url = url..'&units=metric'
	local b, c, h = http.request(url)
	if c ~= 200 then return nil end
	local weather = json:decode(b)
	local city = weather.name
	local country = weather.sys.country
	local temp = 'دمای شهر '..city..' هم اکنون '..weather.main.temp..' درجه سانتی گراد می باشد\n____________________\n @BeyondTeam :)'
	local conditions = 'شرایط فعلی آب و هوا : '
	if weather.weather[1].main == 'Clear' then
		conditions = conditions .. 'آفتابی☀'
	elseif weather.weather[1].main == 'Clouds' then
		conditions = conditions .. 'ابری ☁☁'
	elseif weather.weather[1].main == 'Rain' then
		conditions = conditions .. 'بارانی ☔'
	elseif weather.weather[1].main == 'Thunderstorm' then
		conditions = conditions .. 'طوفانی ☔☔☔☔'
	elseif weather.weather[1].main == 'Mist' then
		conditions = conditions .. 'مه 💨'
	end
	return edit_msg(msg.to.id, msg.id, temp .. '\n' .. conditions, "md")
end
--------------------------------
local function calc(exp)
	url = 'http://api.mathjs.org/v1/'
	url = url..'?expr='..URL.escape(exp)
	b,c = http.request(url)
	text = nil
	if c == 200 then
    text = 'Result = '..b..'\n____________________\n @BeyondTeam :)'
	elseif c == 400 then
		text = b
	else
		text = 'Unexpected error\n'
		..'Is api.mathjs.org up?'
	end
	return edit_msg(msg.to.id, msg.id, text, "md")
end
--------------------------------
function exi_file(path, suffix)
    local files = {}
    local pth = tostring(path)
	local psv = tostring(suffix)
    for k, v in pairs(scandir(pth)) do
        if (v:match('.'..psv..'$')) then
            table.insert(files, v)
        end
    end
    return files
end
--------------------------------
function file_exi(name, path, suffix)
	local fname = tostring(name)
	local pth = tostring(path)
	local psv = tostring(suffix)
    for k,v in pairs(exi_file(pth, psv)) do
        if fname == v then
            return true
        end
    end
    return false
end
--------------------------------
function run(msg, matches) 
if matches[1] == "helpfun" and is_sudo(msg) then
local text = [[
_Self Bot Fun Help Commands:_

*!time*
_Get time in a sticker_

*!short* `[link]`
_Make short url_

*!voice* `[text]`
_Convert text to voice_

*!tr* `[lang] [word]`
_Translates FA to EN and EN to FA_
_Example:_
*!tr fa hi*

*!sticker* `[word]`
_Convert text to sticker_

*!photo* `[word]`
_Convert text to photo_

*!azan* `[city]`
_Get Azan time for your city_

*!calc* `[number]`
Calculator

*!praytime* `[city]`
_Get Patent (Pray Time)_

*!tosticker* `[reply]`
_Convert photo to sticker_

*!tophoto* `[reply]`
_Convert text to photo_

*!weather* `[city]`
_Get weather_

_You can use_ *[!/#]* _at the beginning of commands._

*Good luck ;)*]]
tdbot.sendMessage(msg.from.id, 0, 1, text, 1, 'md')
        return edit_msg(msg.to.id, msg.id, "_Fun help was send in your private message_", "md")
    end
	if matches[1]:lower() == "calc" and matches[2] and is_sudo(msg) then 
		if msg.to.type == "pv" then 
			return 
       end
		return calc(matches[2])
	end
--------------------------------
	if matches[1]:lower() == 'praytime' and is_sudo(msg) or matches[1] == 'azan' and is_sudo(msg) then
		if matches[2] then
			city = matches[2]
		elseif not matches[2] then
			city = 'Tehran'
		end
		local lat,lng,url	= get_staticmap(city)
		local dumptime = run_bash('date +%s')
		local code = http.request('http://api.aladhan.com/timings/'..dumptime..'?latitude='..lat..'&longitude='..lng..'&timezonestring=Asia/Tehran&method=7')
		local jdat = json:decode(code)
		local data = jdat.data.timings
		local text = 'شهر: '..city
		text = text..'\nاذان صبح: '..data.Fajr
		text = text..'\nطلوع آفتاب: '..data.Sunrise
		text = text..'\nاذان ظهر: '..data.Dhuhr
		text = text..'\nغروب آفتاب: '..data.Sunset
		text = text..'\nاذان مغرب: '..data.Maghrib
		text = text..'\nعشاء : '..data.Isha
		text = text..'\n@BeyondTeam\n'
        return edit_msg(msg.to.id, msg.id, text, "html")
	end
--------------------------------
	if matches[1]:lower() == 'tophoto' and is_sudo(msg) and msg.reply_id then
		function tophoto(arg, data)
			function tophoto_cb(arg,data)
				if data.content.sticker then
					local file = data.content.sticker.sticker.path
					local secp = tostring(tcpath)..'/data/stickers/'
					local ffile = string.gsub(file, '-', '')
					local fsecp = string.gsub(secp, '-', '')
					local name = string.gsub(ffile, fsecp, '')
					local sname = string.gsub(name, 'webp', 'jpg')
					local pfile = 'data/photos/'..sname
					local pasvand = 'webp'
					local apath = tostring(tcpath)..'/data/stickers'
					if file_exi(tostring(name), tostring(apath), '') then
						os.rename(file, pfile)
    del_msg(msg.to.id, msg.id)
						        tdbot.sendPhoto(msg.to.id, msg.id, pfile, 0, {}, 0, 0, "@BeyondTeam", 0, 0, 1, nil, dl_cb, nil)
					else
						edit_msg(msg.to.id, msg.id, '_This sticker does not exist. Send sticker again._', 'md')
					end
				else
					edit_msg(msg.to.id, msg.id, '_This is not a sticker._', 'md')
				end
			end
            tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = data.id }, tophoto_cb, nil)
		end
		tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = msg.reply_id }, tophoto, nil)
    end
--------------------------------
	if matches[1]:lower() == 'tosticker' and is_sudo(msg) and msg.reply_id then
		function tosticker(arg, data)
			function tosticker_cb(arg,data)
				if data.content._ == 'messagePhoto' then
					file = data.content.photo.id
					local pathf = tcpath..'/files/photos/'..file..'.jpg'
					local pfile = 'data/photos/'..file..'.webp'
					if file_exi(file..'.jpg', tcpath..'/files/photos', 'jpg') then
						os.rename(pathf, pfile)
    del_msg(msg.to.id, msg.id)
tdbot.sendDocument(msg.to.id, pfile, "@BeyondTeam", nil, msg.id, 0, 1, nil, dl_cb, nil)
					else
						edit_msg(msg.to.id, msg.id, '_This photo does not exist. Send photo again._', 'md')
					end
				else
					edit_msg(msg.to.id, msg.id, '_This is not a photo._', 'md')
				end
			end
			tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = data.id }, tosticker_cb, nil)
		end
		tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = msg.reply_id }, tosticker, nil)
    end
--------------------------------
	if matches[1]:lower() == 'weather' and is_sudo(msg) then
		city = matches[2]
		local wtext = get_weather(city)
		if not wtext then
			wtext = 'مکان وارد شده صحیح نیست'
		end
		return edit_msg(msg.to.id, msg.id, wtext, "md")
	end
--------------------------------
	if matches[1]:lower() == 'time' and is_sudo(msg) then
		local url , res = http.request('http://irapi.ir/time/')
		if res ~= 200 then
			return "No connection"
		end
		local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
		local fonts = {'mathbf','mathit','mathfrak','mathrm'}
		local jdat = json:decode(url)
		local url = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..jdat.ENtime..'}}'
		local file = download_to_file(url,'time.webp')
    del_msg(msg.to.id, msg.id)
tdbot.sendDocument(msg.to.id, file, "@BeyondTeam", nil, msg.id, 0, 1, nil, dl_cb, nil)

	end
--------------------------------
if matches[1] == 'voice' and is_sudo(msg) then
 local text = matches[2]
    textc = text:gsub(' ','.')
    
  if msg.to.type == 'pv' then 
      return nil
      else
  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local file = download_to_file(url,'Self-BotV2.mp3')
     del_msg(msg.to.id, msg.id)
 				tdbot.sendDocument(msg.to.id, file, "@BeyondTeam", nil, msg.id, 0, 1, nil, dl_cb, nil)
   end
end

 --------------------------------
	if matches[1] == "tr" and is_sudo(msg) then 
		url = https.request('https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160119T111342Z.fd6bf13b3590838f.6ce9d8cca4672f0ed24f649c1b502789c9f4687a&format=plain&lang='..URL.escape(matches[2])..'&text='..URL.escape(matches[3]))
		data = json:decode(url)
		local text = 'زبان : '..data.lang..'\nترجمه : '..data.text[1]..'\n____________________\n @BeyondTeam :)'
   return edit_msg(msg.to.id, msg.id, text, "md")
	end
--------------------------------
	if matches[1]:lower() == 'short' and is_sudo(msg) then
		if matches[2]:match("[Hh][Tt][Tt][Pp][Ss]://") then
			shortlink = matches[2]
		elseif not matches[2]:match("[Hh][Tt][Tt][Pp][Ss]://") then
			shortlink = "https://"..matches[2]
		end
		local yon = http.request('http://api.yon.ir/?url='..URL.escape(shortlink))
		local jdat = json:decode(yon)
		local bitly = https.request('https://api-ssl.bitly.com/v3/shorten?access_token=f2d0b4eabb524aaaf22fbc51ca620ae0fa16753d&longUrl='..URL.escape(shortlink))
		local data = json:decode(bitly)
		local u2s = http.request('http://u2s.ir/?api=1&return_text=1&url='..URL.escape(shortlink))
		local llink = http.request('http://llink.ir/yourls-api.php?signature=a13360d6d8&action=shorturl&url='..URL.escape(shortlink)..'&format=simple')
		local text = ' 🌐لینک اصلی :\n'..check_markdown(data.data.long_url)..'\n\nلینکهای کوتاه شده با 6 سایت کوتاه ساز لینک : \n》کوتاه شده با bitly :\n___________________________\n'..(check_markdown(data.data.url) or '---')..'\n___________________________\n》کوتاه شده با u2s :\n'..(check_markdown(u2s) or '---')..'\n___________________________\n》کوتاه شده با llink : \n'..(check_markdown(llink) or '---')..'\n___________________________\n》لینک کوتاه شده با yon : \nyon.ir/'..(check_markdown(jdat.output) or '---')..'\n____________________\n@BeyondTeam'
		return edit_msg(msg.to.id, msg.id, text, "html")
	end
--------------------------------
	if matches[1]:lower() == "sticker" and is_sudo(msg) then 
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.webp')
    del_msg(msg.to.id, msg.id)
		tdbot.sendDocument(msg.to.id, file, "@BeyondTeam", nil, msg.id, 0, 1, nil, dl_cb, nil)
	end
--------------------------------
	if matches[1]:lower() == "photo" and is_sudo(msg) then 
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.jpg')
    del_msg(msg.to.id, msg.id)
tdbot.sendPhoto(msg.to.id, msg.id, file, 0, {}, 0, 0, "@BeyondTeam", 0, 0, 1, nil, dl_cb, nil)
	end
end
end
--------------------------------
return {               
	patterns = {
		"^[#!/](helpfun)$",
		"^[!/#](weather) (.*)$",
		"^[!/](calc) (.*)$",
		"^[#!/](time)$",
		"^[#!/](tophoto)$",
		"^[#!/](tosticker)$",
		"^[!/#](voice) +(.*)$",
		"^[/!#]([Pp]raytime) (.*)$",
		"^[/!#](praytime)$",
		"^[/!#]([Aa]zan) (.*)$",
		"^[/!#](azan)$",
		"^[!/]([Tt]r) ([^%s]+) (.*)$",
		"^[!/]([Ss]hort) (.*)$",
		"^[!/](photo) (.+)$",
		"^[!/](sticker) (.+)$"
		}, 
	run = run,
	}

--#by @BeyondTeam :)
