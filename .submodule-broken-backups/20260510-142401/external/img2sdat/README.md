# img2sdat
Convert sparse filesystem images (.img) into sparse Android data images (.dat)

## Requirements
This binary requires Python 3 or newer installed on your system.

## Usage
```
$ ./img2sdat -h
usage: img2sdat [-h] [-s SOURCE_IMAGE] [-B FILE] [--src-block-map FILE] [-c BYTES] [-o DIR] TARGET_IMAGE

A tool to convert filesystem images into Android data images.

positional arguments:
  TARGET_IMAGE          target partition image

options:
  -h, --help            show this help message and exit
  -s, --src-image SOURCE_IMAGE
                        source partition image
  -B, --tgt-block-map FILE
                        block map file for the target image
  --src-block-map FILE  block map file for the source image
  -c, --cache-size BYTES
                        cache partition size
  -o, --outdir DIR      output directory (default: current directory)
```

## Example
This is a simple example on a Linux system:
```
~$ ./img2sdat.py system.img -o tmp
```
It will create `system.new.dat`, `system.patch.dat` and `system.transfer.list` in the `tmp` directory.

## Info
For more information about this binary, visit it's [XDA page](http://forum.xda-developers.com/android/software-hacking/how-to-conver-lollipop-dat-files-to-t2978952).
