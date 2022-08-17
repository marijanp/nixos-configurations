Config {
  overrideRedirect = False
, font     = "xft:Roboto Mono:pixelsize = 16:antialias=true:hinting=true"
, additionalFonts = [ "xft:Noto Emoji Color:pixelsize = 16:antialias=true:hinting=true" ]
, bgColor  = "#325D79"
, fgColor  = "#EFEEEE"
, allDesktops = True
, position = TopH 30
, commands = [
    Run XMonadLog
  , Run Volume "default" "Master" [ ] 10
  , Run MultiCpu [ "--template" , "CPU: <total0>% <total1>% <total2>% <total3>%" ] 10
  , Run Memory ["--template", "RAM: <usedratio>%"] 10
  , Run Wireless "wlp3s0u1" [] 10
  ]
, alignSep = "}{"
, template = "%XMonadLog% }{ %default:Master% | %multicpu% | %memory% | %net% | %date% "
}

