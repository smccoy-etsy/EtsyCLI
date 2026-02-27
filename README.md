# EtsyCLI

Mostly a collection of scripts for automating daily git chores.  

## Installation

1. Copy the the scripts into `/usr/local/bin/`
2. Specify develop branches in the repo's `.git/config` file. Example:
```
git config scripts.develop "devel-4.0 devel-2.9"
```

3. (Optional) Specify branches to ignore. Example:
```
git config scripts.protected "main release"
```


## Git Scripts

### gitisrebased
Prints "yes" if the current branch is "rebased"; if its merge-base with its parent (see `gitparent`) is the tip of the parent branch. Otherwise, prints "no".   

### gitisnotrebasedlist
Prints a list of local branches that are *not* rebased (see `gitisrebased`). Ignores branches specified in `scripts.develop` and `scripts.protected`.  

### gitparent
Prints the current branch's "parent branch" by finding the nearest commit to HEAD that resides on a branch other than the current branch and printing the name of that branch.

### gitprune
Deletes local branches that have been fully merged into the list of branches specified in `scripts.develop`. Will not delete branches specified in `scripts.develop` or `scripts.protected`. Useful for cleaning up after merging PRs.

### gitrebase
Rebases the current branch onto the tip of its parent branch (See `gitparent`).

### gitupdate
Pulls the branches specified in `scripts.develop`. 


## Other Stuff

### gps
Consumes an exiftool-formatted file and a pair of GPS coordinates, outputs each file's GPS location and distance to the provided coordinates in miles

Example:
```
exiftool -r . > exiftool.txt; gps exiftool.txt "34.24407600461895,-118.46280629069021" > gps.out; say "DONE"
./2024_03_24__05_34_02_exif_img_0127.jpg    35.657352777777774    139.70046944444442    5460.6662328559405
./2024_03_27__18_35_47_exif_img_1226.jpg    35.65688333333333    139.70085277777775    5460.666869314939
./2024_03_26__19_02_20_exif_img_1102.jpg    35.65707777777778    139.70062222222222    5460.669926658948
./2024_04_02__15_45_38_exif_img_2147.jpg    35.660463888888884    139.6977388888889    5460.670806123593
./2024_04_02__15_36_40_exif_img_2146.jpg    35.660441666666664    139.6977527777778    5460.671033265641
./2024_03_26__19_02_17_exif_img_1101.jpg    35.657016666666664    139.70063888888888    5460.67154716929
./2024_03_27__18_16_56_exif_img_1221.jpg    35.65712222222222    139.70053055555553    5460.672428399599
```
