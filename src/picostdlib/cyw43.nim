
{.push header:"pico/cyw43_arch.h".}
proc init*{.importC:"cyw43_arch_init".}
proc deinit*{.importC:"cyw43_arch_deinit".}
proc setGpio*(wl_gpio: cuint, value: bool){.importC:"cyw43_arch_gpio_put".}
proc enableStation*{.importC:"cyw43_arch_enable_sta_mode".}
proc connectWifi*(ssid, password: cstring, mode, timeout_ms: cint): bool {.importC:"cyw43_arch_wifi_connect_timeout_ms".}

