Config {
  overrideRedirect = False
, font     = "Roboto Mono 10"
, bgColor  = "#3b4252"
, fgColor  = "#d8dee9"
, allDesktops = True
, position = TopH 20
, commands = [
    Run XMonadLog
  , Run Volume      "default" "Master" [ ] 10
  , Run MultiCpu    [ "--template" , "CPU: <total0>% <total1>% <total2>% <total3>%" ] 10
  , Run Memory      ["--template", "RAM: <usedratio>%"] 10
  , Run Date        "%a %b %_d %k:%M" "date" 60
  ]
, sepChar = "%"
, alignSep = "}{"
, template = "%XMonadLog% }{ %multicpu% | %memory% | %default:Master% |  %date% "
}

