set pathToSend=C:\Users\Tiamo\Documents\Programming\Games\In Eggcelent Condition\non_game\deliverables
set butlerName=pandaqi/ho-ho-sombrero

butler push "%pathToSend%\windows" %butlerName%:windows
butler push "%pathToSend%\mac" %butlerName%:mac
butler push "%pathToSend%\linux" %butlerName%:linux

pause