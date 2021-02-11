#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
SKETCHES=()

# pa-pa
SKETCHES+=(../examples/HM-LC-Dim1TPBU-FM/HM-LC-Dim1TPBU-FM.ino)
SKETCHES+=(sketches/Beispiel_AskSinPP/examples/RWE/HB-LC-Dim1TPBU-FM_ISD2/HB-LC-Dim1TPBU-FM_ISD2.ino)
SKETCHES+=(sketches/Beispiel_AskSinPP/examples/RWE/HM-LC-Sw1PBU-FM_ISS2/HM-LC-Sw1PBU-FM_ISS2.ino)
SKETCHES+=(sketches/Beispiel_AskSinPP/examples/RWE/HB-LC-Bl1PBU-FM_ISR2/HB-LC-Bl1PBU-FM_ISR2.ino)
SKETCHES+=(sketches/Beispiel_AskSinPP/examples/HM-ES-PMSw1-Pl/HM-ES-PMSw1-Pl.ino)
SKETCHES+=(sketches/Beispiel_AskSinPP/examples/HM-ES-PMSw1-Pl_GosundSP1/HM-ES-PMSw1-Pl_GosundSP1.ino)


# Run tests
HAS_ERROR=false
for FILE in "${SKETCHES[@]}"; do
  echo "Compiling $(basename $FILE)"
  arduino-cli compile \
    --clean \
    --quiet \
    -b MightyCore:avr:644:pinout=bobuino,variant=modelP,LTO=Os,clock=8MHz_internal \
    $FILE
  [ $? -ne 0 ] && HAS_ERROR=true
done

# AES?
#    --build-property "build.extra_flags=-DUSE_AES -DHM_DEF_KEY=0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,0x10 -DHM_DEF_KEY_INDEX=0" \

if $HAS_ERROR; then
  >&2 echo "Errors occurred!"
  exit 1
fi
