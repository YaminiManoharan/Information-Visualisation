1. Make sure that all of the data is in the working directory. Below is the checklist.
	- Tableau File: Assignment3_tableau.twbx
	- R script: city_work.R, event_map.R, transportation_map.R, random.R
	- Data: city_work.csv, event.csv, offStreetCarPark.csv, train.csv, tram.csv
	- Script: execute_r.sh
	- HTML: randomEvent.html
2. Check each R script for the following
	- Install all library
	- Change working directory to your current working directory
3. Open terminal and direct the terminal to the working directory and run execute_r.sh by using this command
	./execute_r.sh
After runing this command, it should run 4 R script on differnt port: 6245, 6246, 6247, 6248
- This method is best for MacBook. However, opening 4 R studio session to run each file also works too.
4. Open Assignment3_tableau.twbx and see the Story Page in the file

Remarks
	- if the maps doesn't show, try reloading the page by right click and choose "Reload"
