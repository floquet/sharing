start_time=$SECONDS  # Record the start time
elapsed=$((SECONDS - start_time))  # Calculate the elapsed time
echo "${SECONDS}"
echo $elapsed
echo "time used = ${elapsed} sec"
