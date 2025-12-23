#!/usr/bin/env bash



echo "cat all conns"
ls -d -I "*.oopsHasChrom*"  /nfs/lab/jnewsome/pbmc/split_cicero/fine/*/cicero_conns_raw/* > /nfs/lab/jnewsome/pbmc/split_cicero/conns_file_list.txt
xargs < /nfs/lab/jnewsome/pbmc/split_cicero/conns_file_list.txt cat > /nfs/lab/jnewsome/pbmc/split_cicero/cat_all_cell_types_raw_conns.txt
echo "done!"

exit 0