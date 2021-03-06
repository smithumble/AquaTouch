try
	set Dvm to do shell script "defaults read com.apple.Safari IncludeDevelopMenu"
	log "dv0: " & Dvm
on error
	try
		tell application "System Events"
			tell application process "Safari"
				--set state to
				if menu "Develop" of menu bar item "Develop" of menu bar 1 exists then
					
					set Dvm to "1"
					log "dv1 yes"
				else
					--return " "
					set Dvm to "0"
					log "dv2 no"
				end if
			end tell
		end tell
	on error
		set Dvm to "2"
		log "dv3 error"
	end try
end try

try
	set Ae to do shell script "defaults read com.apple.Safari AllowJavaScriptFromAppleEvents"
	log "ae0: " & Ae
	
on error
	try
		tell application "System Events"
			tell application process "Safari"
				
				set state to value of attribute "AXMenuItemMarkChar" of menu item "Allow Javascript from Apple Events" of menu "Develop" of menu bar item "Develop" of menu bar 1
				
				if state is "✓" then
					--return "✓"
					set Ae to "1"
					log "ae1 yes"
				else
					--return " "
					set Ae to "0"
					log "ae2 no"
				end if
				
			end tell
		end tell
	on error
		set Ae to "2"
		log "ae3 error"
	end try
end try

--try
log Dvm
log Ae

set Dvm to 2
set Ae to 2

if Dvm is "1" and Ae is "1" then
	log "a"
	set status to "setup complete"
	
else if Dvm is "1" and Ae is "0" then
	log "b"
	set status to "Menu Showing, Disabled"
	
else if Dvm is "0" and Ae is "1" then
	log "c"
	set status to "Develop Menu not Showing"
	
else if Dvm is "1" then
	log "d"
	set status to "Menu Showing, Disabled"
	
else if Dvm is "0" then
	log "e"
	set status to "Develop Menu not Showing"
else
	log "error logic"
	set state to "nothing yet"
	try
		tell application "BetterTouchTool"
			if is_app_running "Safari" then
				tell application "Safari"
					repeat with t in tabs of windows
						log t
						tell t
							if URL starts with "https://www.youtube.com/" then
								set state to do JavaScript "document.getElementById(\"logo-icon-container\").innerHTML;"
							end if
						end tell
					end repeat
				end tell
			end if
		end tell
	on error
		set state to "nothing yet"
	end try
	
	if state is "nothing yet" then
		set status to "fallback"
		else
		set status to "setup complete"
	end if
end if
--end try

log status

--log status
if status is "setup complete" then
	return ""
else if status is "Menu Showing, Disabled" then
	return "⚠️ Setup YouTube Widget   |    Enable \"Allow JavaScript from Apple Events\" from the Develop Menu"
else if status is "Develop Menu not Showing" then
	return "⚠️ Setup YouTube Widget   |    Enable \"Show Develop menu in menu bar\" in [Safari Preferences → Advanced]"
else if status is "error" then
	return "⚠️ Setup YouTube Widget   |    Error scanning safari preferences. Ensure your system is in english, or ask AQT Forums"
else if status is "fallback" then
	return "⚠️ Setup YouTube Widget   |    Enable \"Show Develop menu in menu bar\" in [Safari Preferences → Advanced], then Enable \"Allow JavaScript from Apple Events\" from the Develop Menu"
end if