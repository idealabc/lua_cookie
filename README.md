# lua_cookie

```
  
  local ck = require "resty.cookie"
  
  
  ck.setCookie("uid","12334567", "localhost", ngx.time()+365*86400)

  ck.getCookie("uid")
  
  ck.getAllCookie()
