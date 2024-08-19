#!/bin/bash

# Run the R scripts one by one
Rscript random.R &
Rscript event_map.R &
Rscript city_work.R &
Rscript transportation_map.R &


wait