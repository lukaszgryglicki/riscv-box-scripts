#!/bin/bash
# ALWAYS=1 - process, even if the video is already low res enough
# REMOVE=1 - remove source file if succeeded
# NO_RAND=1 - do not randomize order
# VERBOSE=1 - be verbose directly
#
# To track progress eithe ruse VERBOSE=1 or do `` tail -f convert_all.* adjvid.* ``.
#
> convert_all.log
> convert_all.err
> convert_all.ok
> adjvid.log
> adjvid.err

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
#done < <(find . -type f -iname '* *.*' -print0)

shuffle() {
   local i tmp size max rand

   size=${#fns[*]}
   max=$(( 32768 / size * size ))

   for ((i=size-1; i>0; i--)); do
      while (( (rand=$RANDOM) >= max )); do :; done
      rand=$(( rand % (i+1) ))
      tmp=${fns[i]} fns[i]=${fns[rand]} fns[rand]=$tmp
   done
}

if [ -z "$NO_RAND" ]
then
    shuffle
fi

n_files="${#fns[@]}"
for i in "${!fns[@]}"
do
    f="${fns[$i]}"
    printf "%s/%s\t%s\n" "$i" "$n_files" "$f"
    ls -l "$f"
    if [ ! -z "$VERBOSE" ]
    then
        adjvid.sh "$f"
        result=$?
    else
        adjvid.sh "$f" 1>adjvid.log 2>adjvid.err
        result=$?
    fi
    if [ ! -z "$VERBOSE" ]
    then
        if [ ! "$result" = "0" ]
        then
            echo "failed $f"
        else
            echo "ok $f"
        fi
    else
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
    fi
done

echo 'all ok'
