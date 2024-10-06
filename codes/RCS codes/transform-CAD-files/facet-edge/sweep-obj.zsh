#!/bin/zsh
printf '%s\n' "$(date) $(tput bold)${(%):-%N}$(tput sgr0)"

list=('data/A-PTW.obj' 'data/Frigate-Netgen-0-5m.obj' 'data/me-10.00.obj' 'data/myCarrier-1m.obj' 'data/netgen_moderate.obj' 'data/ng-fine.obj' 'data/ng-moderate.obj' 'data/ng-very-fine.obj' 'data/sphereSuperFine.obj' )

for f in ${list}; do
    echo ""
    echo "./novusFacimus ${f}"
          ./novusFacimus ${f}
done
