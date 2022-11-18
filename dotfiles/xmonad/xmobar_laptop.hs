Config {
  overrideRedirect = False
, font     = "Roboto Mono 20"
, bgColor  = "#3b4252"
, fgColor  = "#d8dee9"
, allDesktops = True
, position = TopH 40
, commands = [
    Run XMonadLog
  , Run Brightness  ["--template", "Br: <percent>%"
                    , "--"
                    , "-D", "/sys/class/backlight/amdgpu_bl0"] 10
  , Run Battery     [ "--template" , "<acstatus>"
                    , "--Low"      , "15"        -- units: %
                    , "--High"     , "80"        -- units: %
                    , "--low"      , "darkred"
                    , "--normal"   , "darkorange"
                    , "--high"     , "white"
                    , "--" -- battery specific options
                    -- discharging status
                    , "-o"	, "<left>% (<timeleft>)"
                    -- AC "on" status
                    , "-O"	, "Charging <left>%"
                    -- charged status
                    , "-i"	, "Charged"
                    ] 60
  , Run Volume      "default" "Master" [ ] 10
  , Run MultiCpu    [ "--template" , "CPU: <total0>% <total1>% <total2>% <total3>%" ] 10
  , Run Memory      ["--template", "RAM: <usedratio>%"] 10
  , Run Date        "%a %b %_d %k:%M" "date" 60
  ]
, sepChar = "%"
, alignSep = "}{"
, template = "%XMonadLog% }{  %battery% | %bright% | %default:Master% | %multicpu% | %memory% | %date% "
}

