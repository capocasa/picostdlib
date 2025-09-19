
# http server
# this is kind of limited and opinionated

type
  # workaround https://github.com/nim-lang/Nim/issues/19588
  CConstCharImpl {.importc:"const char*".} = cstring
  CConstChar* = distinct CConstCharImpl

{.push header: "lwip/apps/httpd.h".}
proc initHttpd*() {.importc: "httpd_init"}

type
  Handler* {.importc: "tCGI", header: "lwip/apps/httpd.h"} = object
    path* {.importc: "pcCGIName"}: cstring
    handler* {.importc: "pfnCGIHandler"}: proc(i, np: cint; k, v: ptr cstring): CConstChar {.cdecl,noSideEffect,gcsafe.}

proc setHandlers*(handlers: ptr Handler; numHandlers: cint) {.importc: "http_set_cgi_handlers".}
{.pop.}

# blocking tcp server
# this needs rtos

const
  NETCONN_TCP* = 0
  NETCONN_COPY* = 0
  CYW43_AUTH_WPA2_AES_PSK* = 3
  ERR_OK* = 0

type
  Netconn* {.importc: "struct netconn", header: "lwip/api.h"} = object
  Netbuf* {.importc: "struct netbuf", header: "lwip/api.h"} = object

{.push header: "lwip/api.h"}
proc initNetconn*(t: cint): ptr Netconn {.importc: "netconn_new".}
proc bindAddress*(conn: ptr Netconn, address: pointer, port: cushort): cint {.importc: "netconn_bind".}
proc listen*(conn: ptr Netconn): cint {.importc: "netconn_listen".}
proc accept*(conn: ptr Netconn, newconn: ptr ptr Netconn): cint {.importc: "netconn_accept".}
proc recv*(conn: ptr Netconn, buf: ptr ptr Netbuf): cint {.importc: "netconn_recv"}
proc write*(conn: ptr Netconn, data: cstring, len: csize_t, apiflags: cuchar): cint {.importc: "netconn_write".}
proc close*(conn: ptr Netconn): cint {.importc: "netconn_close".}
proc delete*(conn: ptr Netconn): cint {.importc: "netconn_delete".}
proc delete*(buf: ptr Netbuf) {.importc: "netbuf_delete".}
{.pop.}

# raw tcp server- if in doubt, use this

type
  Tcp* {.importc: "struct tcp_pcb", header: "lwip/tcp.h".} = object
  Pbuf* {.importc: "struct pbuf", header: "lwip/pbuf.h".} = object
  IpAddr* {.importc: "ip_addr_t", header: "lwip/ip_addr.h".} = object

proc initTcp*(): ptr Tcp {.importc: "tcp_new", header: "lwip/tcp.h".}
proc `bind`*(conn: ptr Tcp, ipaddr: ptr IpAddr, port: cushort): cint {.importc: "tcp_bind", header: "lwip/tcp.h".}
proc listen*(conn: ptr Tcp): ptr Tcp {.importc: "tcp_listen", header: "lwip/tcp.h".}
#proc accept*(conn: ptr Tcp, accept: proc(arg: pointer, conn: ptr Tcp, err: cint): cint {.cdecl.}) {.importc: "tcp_accept", header: "lwip/tcp.h".}
proc accept*(conn: ptr Tcp, accept: pointer) {.importc: "tcp_accept", header: "lwip/tcp.h".}
#proc write*(conn: ptr Tcp, data: pointer, length: cushort, flags: cuchar): cint {.importc: "tcp_write", header: "lwip/tcp.h".}
proc write*(conn: ptr Tcp, data: cstring, length: cushort, flags: cuchar): cint {.importc: "tcp_write", header: "lwip/tcp.h".}
proc output*(conn: ptr Tcp): cint {.importc: "tcp_output", header: "lwip/tcp.h".}
proc close*(conn: ptr Tcp): cint {.importc: "tcp_close", header: "lwip/tcp.h".}
#proc receive*(conn: ptr Tcp, receive: proc(arg: pointer, conn: ptr Tcp, p: ptr Pbuf, err: cint): cint {.cdecl.}) {.importc: "tcp_recv", header: "lwip/tcp.h".}
proc receive*(conn: ptr Tcp, receive: pointer) {.importc: "tcp_recv", header: "lwip/tcp.h".}

proc free*(p: ptr Pbuf) {.importc, header: "lwip/pbuf.h".}

