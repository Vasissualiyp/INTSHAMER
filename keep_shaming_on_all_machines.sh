#/bin/bash

while true; do
  date
  ./run_shame_detector_on_all_machines.sh
  echo "Latest refresh: $(date)" > last_refresh.txt
  sleep 10
done
