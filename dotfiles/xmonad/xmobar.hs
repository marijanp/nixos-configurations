Config {
  overrideRedirect = False
, font     = "xft:Roboto Mono:pixelsize = 16:antialias=true:hinting=true"
, bgColor  = "#325D79"
, fgColor  = "#EFEEEE"
, allDesktops = True
, position = TopH 30
, commands = [
    Run XMonadLog
  , Run DynNetwork ["--template", "Down: <rx> kB/s Up: <tx> kB/s"
                   ,"--High",     "400"
                   ,"--Low",      "10"
                   ,"--high",     "#bbc2cf"
                   ,"--low",      "#bbc2cf"
                   ] 10
  , Run Volume "default" "Master" [ ] 10
  , Run MultiCpu    [ "--template" , "CPU: <total0>% <total1>% <total2>% <total3>%" ] 10
  , Run Memory      ["--template", "RAM: <usedratio>%"] 10
  , Run Date      "%a %b %_d %k:%M" "date" 60
  ]
, sepChar = "%"
, alignSep = "}{"
, template = "%XMonadLog% }{ %dynnetwork% | %default:Master% | %multicpu% | %memory% | %date% "
}

