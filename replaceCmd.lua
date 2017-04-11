function dealString(sfile)
    local scrfile = sfile
    local desfile = "temp.cpp"
	local file = assert(io.open(scrfile,"r"))
	local f    = assert(io.open(desfile,"w"))
	local obj_data = ""
	local obj_type = "Cmd::EQUIPACTION_REFRESH"
	local flag = 1
	for line in file:lines() do
		if string.find(line,"Cmd::stAddObjectPropertyUserCmd") then
			if string.find(line,‘//’) then
			else
				flag=1
			end
		end
		if flag = 1 then 
			if string.find(line,'bcopy') then
				local start = string.find(line,'&')
				local endstr = string.find(line,',')
				obj_data = string.sub(line,start+1,endstr-1)
			end
			if string.find(line,'memcpy') then 
				local str = string.gsub(line,'$','#',1)
				str = string.gsub(line,',','#',1)
				local start = string.find(line,'&')
				local endstr = string.find(line,',')
				obj_data = string.sub(line,start+1,endstr-1)
			end
			if string.find(line,'=') then
			    local start = string.find(line,'=')
				local endstr = string.find(line,';')
				obj_data = string.sub(line,start+1,endstr-1)
			end
		end
		
		if flag == 0 then 
			f:write(line .. "\n")
		end
		
		if flag == 1 then 
			if string.find(line,'sendCmdToMe') then
				local str string.gsub(line,'sendCmdToMe','sendObjectToMe')
				local a = string .find(str,'%(')
				local b = string.sub(str,1,a-1)
				b = b .."(" .. obj_data .. ",".. obj_type .. ");\n"
				f:write(b)
				flag = 0
				obj_data = ""
			end
		end
	end
	
	file:close()
	f:close()
	os.remove(scrfile)
	os.rename(desfile,scrfile)
end


if arg[1] ~= nil then
	cmd = "ls ".. arg[1]
else
	cmd = "ls"
end

local s = io.popen(cmd)
local fileLists  = s:read("*all")

while true do
	_,end_pos,line = string.find(fileLists,"([^\n\r]+.cpp)",start_pos)
	if line ~= nil then
		break
	end
	
	dealString(arg[1].."/"..line)
end
