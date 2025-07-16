#!/bin/bash

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
  tot_ram_gib=$(echo "$tot_ram_tib * 1000" | bc)
else
  tot_ram_gib=$(echo $tot_ram_str | sed "s/Gi//")
fi
tot_ram_gb=$(echo "$tot_ram_gib * 1000 * 1000 * 1000 /1024 / 1024 / 1024" | bc)

used_cpu=$(echo "$highest_cpu_amount / 100" | bc )
used_ram=$(echo "$highest_ram_amount / 1024 / 1024" | bc )
filename=$(uname -n).shame

# Printout the results
echo "Highest RAM usage on $(uname -n) as of $(date):" > $filename
echo "$highest_ram_user, $used_ram / $tot_ram_gb GB" >> $filename

echo "Highest CPU usage on $(uname -n) as of $(date):" >> $filename
echo "$highest_cpu_user, $used_cpu / $num_cpus CPUs" >> $filename
