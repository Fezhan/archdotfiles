#!/bin/python

import os
import subprocess
import sys

def getFiles(folder_path):
    files_array = []

    # Check if the folder path exists
    if not os.path.exists(folder_path):
        print(f"The folder '{folder_path}' does not exist.")
        return files_array

    # Iterate through the files in the folder
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)

        # Check if it is a file (not a subfolder)
        if os.path.isfile(file_path):
            files_array.append(filename)

    return files_array

def currentWall():
    result = subprocess.run("swww query", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode == 0:
        wallpaper = result.stdout.split("\n")[0]
        return wallpaper[81:]
    else:
        return False


# Replace 'your_folder_path' with the path to the folder you want to iterate through
folder_path = '/home/faiyaz/wallpapers'
files = getFiles(folder_path)

wallpaper = currentWall()

if files == 0:
    print("No files found")
    sys.exit(1)

if wallpaper == False:
    print("No wallpaper set")
    sys.exit(1)

if wallpaper in files:
    nextWall = files.index(wallpaper) + 1
    if nextWall >= len(files):
        nextWall = 0
    command = "swww img /home/faiyaz/wallpapers/\"" + str(files[nextWall] + "\"")
    print(command)
    subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    print("Wallpaper changed")
    sys.exit(0)
else:
    print("Could not get current wallpaper index!")
    sys.exit(2)