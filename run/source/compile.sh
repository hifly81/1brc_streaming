#!/bin/bash

brew tap SergioBenitez/osxct
brew install x86_64-unknown-linux-gnu
brew install mingw-w64

BREW_HOME=/opt/homebrew/Cellar

echo -e "Compile data.c"
gcc -o ../darwin/data_arm data.c
$BREW_HOME/mingw-w64/11.0.1/bin/x86_64-w64-mingw32-gcc -o ../windows/data.exe data.c
$BREW_HOME/x86_64-unknown-linux-gnu/7.2.0/bin/x86_64-unknown-linux-gnu-gcc -o ../linux/data_x86_64 data.c
clang -arch x86_64 -O0 -g data.c -o ../darwin/data_x86_64

echo -e "Compile consumer.c"
gcc -lrdkafka -I$BREW_HOME/librdkafka/2.3.0/include/librdkafka consumer.c -L$BREW_HOME/librdkafka/2.3.0/lib -o ../darwin/consumer_arm