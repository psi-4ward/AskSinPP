#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
SKETCHES=()

jp112sdl=(
  HB-LC-Bl1PBU-FM
  HB-LC-SW12-FM
  HB-LC-Sw1PBU-FM
  HB-LC-Sw2PBU-FM
  HM-CC-SCD
  HM-Dis-TD-T
  HM-ES-TX-WM_CCU
  HM-LC-SW1-FM_Shelly1
  HM-LC-SW1-SM_SONOFF_BASIC
  HM-LC-Sw1-Pl-CT-R1
  HM-LC-Sw1-Pl-DN-R1
  HM-LC-Sw1-Pl-DN-R1_OBI
  HM-LC-Sw2-FM
  HM-MOD-Re-8
  HM-PB-2-FM
  HM-PB-2-WM55
  HM-PB-6-WM55
  HM-PB-MP-WM
  HM-PBI-4-FM
  HM-RC-2-PBU-FM
  HM-SCI-3-FM
  HM-SWI-3-FM
  HM-SEC-SC
  HM-SEC-SCO
  HM-Sec-TiS
  HM-Sen-DB-PCB
  HM-Sen-LI-O
  HM-Sen-WA-OD
  HM-WDS30-OT2-DS18B20
  HM-WDS30-OT2-NTC
  HM-WDS30-T-O-NTC
  HM-WDS40-TH-I-BME280
  HM-WDS40-TH-I-DHT22
  HM-WDS40-TH-I-SHT10
)
for S in "${jp112sdl[@]}"; do
  SKETCHES+=(sketches/Beispiel_AskSinPP/examples/$S/$S.ino)
done


# Run tests
HAS_ERROR=false
for FILE in "${SKETCHES[@]}"; do
  echo "Compiling $(basename $FILE)"
  arduino-cli compile \
    --clean \
    --quiet \
    -b arduino:avr:pro:cpu=8MHzatmega328 \
    $FILE
  [ $? -ne 0 ] && HAS_ERROR=true
done

# AES?
#    --build-property "build.extra_flags=-DUSE_AES -DHM_DEF_KEY=0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,0x10 -DHM_DEF_KEY_INDEX=0" \

if $HAS_ERROR; then
  >&2 echo "Errors occurred!"
  exit 1
fi
