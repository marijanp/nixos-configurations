Config {
  overrideRedirect = False
, font     = "xft:Roboto Mono:pixelsize = 16:antialias=true:hinting=true"
, bgColor  = "#325D79"
, fgColor  = "#EFEEEE"
, allDesktops = True
, position = TopH 30
, commands = [
    Run XMonadLog
  , Run Volume "default" "Master" [ ] 10
  , Run MultiCpu [ "--template" , "CPU: <total0>% <total1>% <total2>% <total3>%" ] 10
  , Run Memory ["--template", "RAM: <usedratio>%"] 10
  , Run DynNetwork ["-t"," Down: <rx> kB/s Up: <tx> kB/s"
                   ,"-H","400"
                   ,"-L","10"
                   ,"-h","#bbc2cf"
                   ,"-l","#bbc2cf"
                   ,"-n","#bbc2cf"] 10
  ]
, sepChar = "%"
, alignSep = "}{"
, template = "%XMonadLog% }{ %default:Master% | %multicpu% | %memory% | %dynnetwork% | %date% "
}

