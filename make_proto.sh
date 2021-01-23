#!/bin/bash

baseDir="."
srcDir=$baseDir/proto-src/
outDir=$baseDir/proto/

for file in $(ls $srcDir); do

  fileName=${file%.*}
  fileSuffix=${file#*.}

  if [[ "$fileSuffix" == "proto" ]]; then
    echo "protoc -o "$outDir$fileName".pb "$srcDir$fileName".proto"
    protoc -o $outDir$fileName".pb" $srcDir$fileName".proto"
  else
    echo $file "is not a protobuf file"
  fi

done
