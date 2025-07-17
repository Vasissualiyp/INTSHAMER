#/bin/bash

machine_names="mussel kingcrab homard lobster calamari shrimp prawn ricky"
file_types="shame cpu_monopoly ram_monopoly ram_user cpu_user"
ricky_address="128.100.76.112"
user=$(whoami)
timeout=20

rsync_ricky() {
  for type in $file_types; do
    timeout $timeout rsync "$user@$ricky_address:/home/$user/INTSHAMER/ricky.$type" "ricky.$type"
  done
}

for machine in $machine_names; do
  timeout $timeout ssh $machine "cd /home/vpustovoit/INTSHAMER/; ./find_the_worst_user_local.sh" &&  echo "Success on $machine"|| $(echo "Failed to ssh into $machine" > $machine.shame)
  if [[ "$machine" == "ricky" ]]; then
    rsync_ricky
  fi
  for type in $file_types; do
    chmod a+r $machine.$type
  done
done
