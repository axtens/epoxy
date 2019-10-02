# epoxy
A REST-based proxy management tool, written in B4J.
```
  	gSrvr.AddHandler("/epoxy", "MainHandler", False) 'GET/PUT/POST/DELETE
	gSrvr.AddHandler("/epoxy/remove", "RemoveHandler", False) 'DELETE
	gSrvr.AddHandler("/epoxy/export", "ExportHandler", False) 'PUT
	gSrvr.AddHandler("/epoxy/import", "ImportHandler",False) 'GET
	gSrvr.AddHandler("/epoxy/count","CountHandler",False) 'GET
	gSrvr.AddHandler("/epoxy/list","ListHandler",False) 'GET
	gSrvr.AddHandler("/epoxy/list/all","ListHandler",False) 'GET 
	gSrvr.AddHandler("/epoxy/shutdown","ShutdownHandler", False) 'PUT
	gSrvr.AddHandler("/epoxy/version","VersionHandler",False) 'GET
	gSrvr.AddHandler("/epoxy/error","ErrorHandler",False) 'PUT
  ```
  Implements a REST server for logging proxy use details (back when we were using publicly listed proxies.) Database is in-memory and must be exported or data will be lost.
