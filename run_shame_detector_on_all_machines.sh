#/bin/bash

machine_names="mussel kingcrab homard lobster calamari shrimp prawn ricky"
timeout=20

for machine in $machine_names; do
  timeout $timeout ssh $machine "cd /home/vpustovoit/INTSHAMER/; ./find_the_worst_user_local.sh" &&  echo "Success on $machine"|| $(echo "Failed to ssh into $machine" > $machine.shame)
  chmod a+r $machine.shame
done
