
echo "MUTEX POSIX TEST"
date
ALTIBASE_MUTEX_TYPE=0
export ALTIBASE_MUTEX_TYPE
./testMutex
date


echo "MUTEX NATIVE TEST"; 
date
ALTIBASE_MUTEX_TYPE=1
export ALTIBASE_MUTEX_TYPE
testMutex
date

echo "LATCH POSIX TEST"; 
date
ALTIBASE_LATCH_TYPE=0
export ALTIBASE_LATCH_TYPE
testLatch
date

echo "LATCH NATIVE TEST"; 
date
ALTIBASE_LATCH_TYPE=1
export ALTIBASE_LATCH_TYPE
testLatch
date
