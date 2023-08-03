#!/usr/bin/env sh

# Use -v options to print more info during debug.
#     Some additional info are the name of queries that ends correctly.
#     You should omit those printings, especially while running on CI.

SIMPLE_DATA='Progetto_2_3.ttl'
INFERRED_DATA='inferred.ttl'
EXT='.rq'
ERRORS=''

# Good resulting queries
# GQ="001_getAllStudents,7 002_getAllLessonsOfWrk,3"
#     TODO: Those queries should be gatether using an input stream.
GQ=$(cat <<-END
001_getAllStudents,7
002_getAllLessonsOfWrk,4
003_getLessonsFrequencyOfStudents,4
004_getStudentsWithAtLeastOneFrequency,4
005_getStudentsWithAtLeast75PercFrequency,2
006_getNumberOfExamTriesOfWrk,4
007_getPercentageOfLessonsInDelay,4
008_getLessonsOfWrkWithTutor,2
009_getStudentsOfALessonWithAttendance,4
011_getStillValidPins,3
012_getRegisterOfAnExam,4
013_getLastValidPin,2
016_getWorkgroupWithLeastPartecipation,4
END
)
for query in $GQ
do
    ARG="$(echo $query | cut -d',' -f1)" # Get first param
    EXP="$(echo $query | cut -d',' -f2)" # Get second param
    RES=`arq --data=${SIMPLE_DATA} --query=sparql/${ARG}${EXT} --results=csv | wc -l`
    if [ $RES -ne $EXP ]; then
        ERRORS="${ERRORS}\r\nNope! $ARG expected $EXP instead of $RES\r\n\r\n"
    else
        [ "$1" = "-v" ] && echo $ARG
    fi
done

# Failing queries
BQ="002a_getAllLessonsOfDA,1"
for query in $BQ
do
    ARG="$(echo $query | cut -d',' -f1)" # Get first param
    EXP="$(echo $query | cut -d',' -f2)" # Get second param
    RES=`arq --data=${SIMPLE_DATA} --query=sparql/${ARG}${EXT} --results=csv | wc -l`
    if [ $RES -ne $EXP ]; then
        ERRORS="${ERRORS}\r\nNope! $ARG expected $EXP instead of $RES\r\n\r\n"
    fi
done

# Data queries
# [ "$1" = "-v" ] && echo "Leggo percentuali"
# Leggo il risultato di una query
# RES=`arq --data=${INFERRED_DATA} --query=sparql/003_getLessonsFrequencyOfStudents.rq --results=csv`
# [ "$1" = "-v" ] && echo $RES
# Estraggo il valore della percentuale
# while read -r line; do
#     echo $line
# done <(echo "$RES")

if [ -z "$ERRORS" ]; then # Check if we have some errors.
    exit 0
else
    echo $ERRORS
    exit 1
fi
