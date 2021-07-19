@echo off

REM change into scripts directory, so that relative paths are always correct, no matter from where the script was called
set current_dir=%~dp0
pushd %current_dir%

REM compile debug build
win32\cross9\bin\x86_64-pc-linux-gnu-gcc.exe -g -O -o bootstripper.com.dbg src\bootstripper.c^
  -static -fno-pie -no-pie -mno-red-zone -fno-omit-frame-pointer -nostdlib -nostdinc^
  -Wl,--gc-sections -Wl,-z,max-page-size=0x1000 -fuse-ld=bfd^
  -Wl,-T,cosmopolitan\ape.lds -include cosmopolitan\cosmopolitan.h cosmopolitan\crt.o cosmopolitan\ape.o cosmopolitan\cosmopolitan.a

REM transform debug build into release build
win32\cross9\bin\x86_64-pc-linux-gnu-objcopy.exe -S -O binary bootstripper.com.dbg bootstripper.com

popd

REM run release build
%current_dir%bootstripper.com
