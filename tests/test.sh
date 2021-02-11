#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
source _functions.sh
uname -a

SKETCH_PATHES=(
  ../examples
  sketches
)

BOARD=$1

if [ -z "$BOARD" ] ; then
  >&2 echo "ERROR: Board argument missing"
  exit 1
fi

case "$BOARD" in
  328p)
    CORE=""
    FQBN=arduino:avr:pro:cpu=8MHzatmega328
    ;;
  644p)
    CORE=MightyCore:avr
    FQBN=MightyCore:avr:644:pinout=bobuino,variant=modelP,LTO=Os,clock=8MHz_internal
    ;;
  bluepill)
    CORE=stm32duino:STM32F1
    FQBN=stm32duino:STM32F1:genericSTM32F103C
    ;;
  maplemini)
    CORE=stm32duino:STM32F1
    FQBN=stm32duino:STM32F1:mapleMini
    ;;
  *)
    >&2 echo "ERROR: Unknown board \"${BOARD}\""
    exit 1
esac

# Find sketches
findSketches ${BOARD}

# Install core
echo Install arduino:avr core
arduino-cli core install arduino:avr
if [ -n "${CORE}" ] ; then
  echo Install ${CORE} core
  arduino-cli core install ${CORE}
fi

# Run tests without AES
RES1=0
if [ ${#SKETCHES[@]} -gt 0 ]; then
  runTests "${FQBN}" false "${SKETCHES[@]}"
  RES1=$?
  echo "::warning ::warning Compiled ${#SKETCHES[@]} Sketches for ${BOARD}. Average space consumption ${AVG_BYTES} Bytes"
fi

# Run tests with AES
RES2=0
if [ ${#SKETCHES_AES[@]} -gt 0 ]; then
  runTests "${FQBN}" true "${SKETCHES_AES[@]}"
  RES2=$?
  echo "::warning ::warning Compiled ${#SKETCHES[@]} Sketches with AES supprt for ${BOARD}. Average space consumption ${AVG_BYTES} Bytes"
fi

if [ $RES1 -gt 0 ] || [ $RES2 -gt 0 ]; then
  >&2 echo "Errors occurred!"
  exit 1
fi
