#!/bin/bash

monopoly_threshold=0.2

# Highest RAM
highest_ram_user=$(ps -eo user,rss --no-headers | awk '
  { ram[$1] += $2 }
  END {
    max_ram = 0;
    user = "nobody";
    for (u in ram) {
      if (ram[u] > max_ram) {
        max_ram = ram[u];
        user = u;
      }
    }
    print user;
  }')
highest_ram_amount=$(ps -eo user,rss --no-headers | awk '
  { ram[$1] += $2 }
  END {
    max_ram = 0;
    user = "nobody";
    for (u in ram) {
      if (ram[u] > max_ram) {
        max_ram = ram[u];
        user = u;
      }
    }
    print max_ram;
  }')


# Highest CPU
highest_cpu_user=$(ps -eo user,pcpu --no-headers | awk '
  { cpu[$1] += $2 }
  END {
    max_cpu = 0;
    user = "nobody";
    for (u in cpu) {
      if (cpu[u] > max_cpu) {
        max_cpu = cpu[u];
        user = u;
      }
    }
    print user;
  }')
highest_cpu_amount=$(ps -eo user,pcpu --no-headers | awk '
  { cpu[$1] += $2 }
  END {
    max_cpu = 0;
    user = "nobody";
    for (u in cpu) {
      if (cpu[u] > max_cpu) {
        max_cpu = cpu[u];
        user = u;
      }
    }
    print max_cpu;
  }')

# Find total numbers of computer parameters
num_cpus=$(lscpu | grep "CPU(s):" | awk '{print $2}' | head -n 1)
tot_ram_str=$(free -h | head -n 2 | tail -n 1 | awk '{print $2}')
if [[ "$tot_ram_str" == *"Ti"* ]]; then
  tot_ram_tib=$(echo $tot_ram_str | sed "s/Ti//")
  tot_ram_gib=$(echo "$tot_ram_tib * 1024" | bc)
else
  tot_ram_gib=$(echo $tot_ram_str | sed "s/Gi//")
fi
tot_ram_gb=$(echo "$tot_ram_gib" | bc)

used_cpu=$(echo "$highest_cpu_amount / 100" | bc )
used_ram=$(echo "$highest_ram_amount / 1024 / 1024" | bc )
shame_file=$(uname -n).shame
ram_user_file=$(uname -n).ram_user
cpu_user_file=$(uname -n).cpu_user
ram_monopoly_file=$(uname -n).ram_monopoly
cpu_monopoly_file=$(uname -n).cpu_monopoly




# Print out the results into the .shame file
echo "Highest RAM usage on $(uname -n):" > $shame_file
echo "$highest_ram_user, $used_ram / $tot_ram_gb GB" >> $shame_file

echo "Highest CPU usage on $(uname -n):" >> $shame_file
echo "$highest_cpu_user, $used_cpu / $num_cpus CPUs" >> $shame_file




# Print the last time of RAM user change
last_ram_user=$(cat $ram_user_file | awk '{print $1}')
last_time_ram=$(cat $ram_user_file | awk '{print $2}')

if [[ "$last_ram_user" == "$highest_ram_user" ]]; then
  ram_user_time=$last_time_ram
else
  ram_user_time=$(date +%s)
fi
echo "$highest_ram_user $ram_user_time" > $ram_user_file


# Check for RAM Monopoly conditions
ram_monopoly_time=$(echo "$(date +%s) - $ram_user_time" | bc)
monopoly_frac=$(echo "$used_ram / $tot_ram_gb" | bc -l)
if [ 1 -eq "$(echo "$monopoly_frac > $monopoly_threshold" | bc)" ]; then
    echo "$highest_ram_user $ram_monopoly_time" > $ram_monopoly_file
else
    echo "none 0" > $ram_monopoly_file
fi



# Print the last time of CPU user change
last_cpu_user=$(cat $cpu_user_file | awk '{print $1}')
last_time_cpu=$(cat $cpu_user_file | awk '{print $2}')

if [[ "$last_cpu_user" == "$highest_cpu_user" ]]; then
  cpu_user_time=$last_time_cpu
else
  cpu_user_time=$(date +%s)
fi
echo "$highest_cpu_user $cpu_user_time" > $cpu_user_file



# Check for CPU Monopoly conditions
cpu_monopoly_time=$(echo "$(date +%s) - $cpu_user_time" | bc)
monopoly_frac=$(echo "$used_cpu / $num_cpus" | bc -l)
if [ 1 -eq "$(echo "$monopoly_frac > $monopoly_threshold" | bc)" ]; then
    echo "$highest_cpu_user $cpu_monopoly_time" > $cpu_monopoly_file
else
    echo "none 0" > $cpu_monopoly_file
fi
