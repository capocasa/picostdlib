{.emit: "#include \"lwip/netif.h\""}

proc init*{.importc:"cyw43_arch_init", header:"pico/cyw43_arch.h".}
proc deinit*{.importc:"cyw43_arch_deinit", header:"pico/cyw43_arch.h".}
proc setGpio*(wl_gpio: cuint, value: bool){.importc:"cyw43_arch_gpio_put", header:"pico/cyw43_arch.h".}
proc enableStation*{.importc:"cyw43_arch_enable_sta_mode", header:"pico/cyw43_arch.h".}
proc connectWifi*(ssid, password: cstring, mode, timeout_ms: cint): bool {.importc:"cyw43_arch_wifi_connect_timeout_ms", header:"pico/cyw43_arch.h".}
proc protectBegin*() {.importc: "cyw43_arch_lwip_begin", header:"pico/cyw43_arch.h".}
proc protectEnd*() {.importc: "cyw43_arch_lwip_end", header:"pico/cyw43_arch.h".}

type
  Netif* {.importc: "struct netif", header: "lwip/netif.h".} = object
    hostname* {.importc: "hostname".}: cstring
  State* {.importc: "cyw43_t", header: "pico/cyw43_arch.h"} = object
    netif* {.importc: "netif".}: array[2, Netif]

proc setHostname*(netif: ptr Netif, name: cstring) =
  if netif != nil:
    netif.hostname = name
  # translation from C macro. TODO: see if nil case needs handling

#proc setUp*(n: ptr Netif) {.importc: "netif_set_up".}

template withProtect*(body: untyped) =
  protectBegin()
  body
  protectEnd()



