#/bin/bash

machine_names="mussel kingcrab homard lobster calamari shrimp prawn"

for machine in $machine_names; do
  rm -f "$machine.shame"
  ssh $machine "cd /home/vpustovoit/INTSHAMER/; ./find_the_worst_user_local.sh" &&  echo "Success on $machine"|| echo  "Failed on $machine" && echo "Failed to ssh into $machine" > $machine.shame
done
