# sonic-automated-image-builder
bash script to automate building sonic images on linux

## test environment
- OS: ubuntu 16.04
- RAM: 32GB
- CPU: 8 cores
- storage: 256GB (at least 50GB free space is necessary)

## how to use
the script expects one argument that specifies the platform which could be one of the following vendors

```
ASIC_vendor = broadcom | nephos | cavium | barefoot | innovium | centec | marvell | mellanox
```

:warning: do not run the script in a subshell (which is what happens when use the command `./build-image.sh [vendor]`) instead source the file so it runs on the current shell `. ./build-image.sh [vendor]`
