import os
import subprocess
import time

def getFiles(folder_path):
    files_array = []

    if not os.path.exists(folder_path):
        print(f"The folder '{folder_path}' does not exist.")
        return files_array

    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
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

def main():
    folder_path = '/home/faiyaz/wallpapers'
    files = getFiles(folder_path)

    wallpaper = currentWall()

    if not files:
        print("No files found")
        return

    if not wallpaper:
        print("No wallpaper set")
        return

    if wallpaper in files:
        nextWall = files.index(wallpaper) + 1
        if nextWall >= len(files):
            nextWall = 0
        command = f"swww img /home/faiyaz/wallpapers/{files[nextWall]}"
        print(command)
        subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        print("Wallpaper changed")
    else:
        print("Could not get the current wallpaper index!")

while True:
    main()
    time.sleep(300)
