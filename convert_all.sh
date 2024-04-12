#!/bin/bash
# ALWAYS=1 - process, even if the video is already low res enough
# REMOVE=1 - remove source file if succeeded
> convert_all.log
> convert_all.err
> convert_all.ok

declare -a fns=()
while IFS= read -d $'\0' -r f
do
    if [[ "$f" == *_adjvid.mp4 ]]
    then
        echo "skipping $f"
        continue
    fi
    fns+=("$f")
done < <(find . -type f ! -iname '*_adjvid.mp4' -print0)

n_files="${#fns[@]}"
for i in "${!fns[@]}"
do
    f="${fns[$i]}"
    printf "%s/%s\t%s\n" "$i" "$n_files" "$f"
    ls -l "$f"
    adjvid.sh "$f" 1>adjvid.log 2>adjvid.err
    result=$?
    if [ ! "$result" = "0" ]
    then
        echo "failed $f"
        echo "failed $f" >> convert_all.err
        echo "failed $f" >> convert_all.log
        cat adjvid.log >> convert_all.log
        cat adjvid.err >> convert_all.err
    else
        echo "ok $f"
        echo "ok $f" >> convert_all.ok
    fi
done

echo 'all ok'
