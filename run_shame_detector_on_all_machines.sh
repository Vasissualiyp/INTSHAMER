#/bin/bash

machine_names="mussel kingcrab homard lobster calamari shrimp prawn"
machine_names="mussel kingcrab homard lobster shrimp prawn"

for machine in $machine_names; do
  rm -f "$machine.shame"
  ssh $machine "cd /home/vpustovoit/INTSHAMER/; ./find_the_worst_user_local.sh"
done

#ssh prawn "cd /home/vpustovoit/INTSHAMER/; ./find_the_worst_user_local.sh"
