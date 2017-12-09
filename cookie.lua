_M = {}
--取所有cookie
function _M.getAllCookie( ... )
    local str = ngx.var.http_cookie
    local t = {}
    if str and type(str)=="string" then
        for s in string.gmatch(str, "([^".."; ".."]+)") do
            if s and type(s)=="string" then
                local i = 1
                local k = {} 
                for v in string.gmatch(s, "([^".."=".."]+)") do
                    k[i] = v;
                    i = i +1
                end
                if k[2] then
                    table.insert(t,{["name"]=k[1],["value"]=k[2]})
                end
            end
        end
    end
    if #t>0 then
        return t
    end
    return nil
end
--取一个cookie
function _M.getCookie( name, cookie )
    if type(cookie)=="nil" then
        cookie = _M.getAllCookie()
    end
    if type(cookie)=="table" then
        for k,v in pairs(cookie) do
            if name==v["name"] then
                return v
            end
        end
    end
    return nil
end
-- 设置cookie, 在种cookie之前不能有ngx.say的输出，不然会有溢出BUG
function _M.setCookie(name, value, domain, expires)
    -- format the date
    if type(expires) == "number" then
        expires = os.date("!%a, %d-%m-%Y %H:%M:%S GMT", expires)
    end
    local set_cookie = ngx.header["Set-Cookie"]
    local header = name .. '=' .. value .. '; path=/; '
    if domain then
       header = header .. "domain=" .. domain .. "; "
    end
    if expires then
       header = header .. "expires=" .. expires .. "; "
    end
    if set_cookie == nil then
        ngx.header["Set-Cookie"] = header
    elseif type(set_cookie) == "string" then
        ngx.header["Set-Cookie"] = {set_cookie, header}
    elseif type(set_cookie) == "table" then
        table.insert(set_cookie, header)
        ngx.header["Set-Cookie"] = set_cookie
    else
        return false
    end

    return true
end

return _M