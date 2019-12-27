# Importing Libaries
import sys
import os
import pygit2 as git
import requests

# Constants
VERSION = "2.0"
BASE_PATH = os.getcwd()

GIT_URL = "git://github.com/AStupidRat/RatPoison.git"
GRADLE_URL = "https://raw.githubusercontent.com/AStupidRat/RatPoison/master/build.gradle"

def check_version():
    """This will find and get the current version for RatPoision.
    
    Returns:
        str: The current version of RatPoison.
    """

    # Send a get request to the build.gradle.
    response = requests.get(GRADLE_URL)

    # Split the contents of build.gradle for searching.
    lines = response.text.split("\n")
    
    # Declaring the Version.
    version = "INVALID"

    for line in lines:
        if "version \"" in line:
            start = len("version \"")
            end = len(line) - 1

            version = line[start:end]

            break
    
    return version

def clone_repo(path):
    """This will clone the repository for RatPoision
    
    Args:
        path: This is the path where RatPoision will be cloned.
    
    Returns:
        bool: If the path is already created.
    """
    
    if os.path.exists(BASE_PATH + "/" + path):
        return False
    
    git.clone_repository(GIT_URL, path)

    return True

def build_rat_poision(path):
    """This will build RatPoision

    Args:
        path: This is the base folder for RatPoision.
    """

    os.chdir(path)

    os.system("call build.bat")

def start_rat_poision(path):
    """This will start RatPoision

    Args:
        path: This is the base folder for RatPoision.
    """
    

    os.chdir(BASE_PATH)
    os.chdir(path + "\\build\\" + path)
    
    os.system("call \"Start " +  path + "\".bat")
    
def main():
    """This is the main of the file"""

    os.system("title RatPoison updater version: " + VERSION)
    
    version = check_version()
    path = "RatPoison " + version
    
    print("Current version is of RatPoison is " + version)

    # Clone, build, and start.
    cloned = clone_repo(path)
    
    print("Cloned to " + path)

    if cloned:
        print("Building Rat Poision")
        build_rat_poision(path)

        print("Starting Rat Poision")
        start_rat_poision(path)
    else:
        print("Starting Rat Poision")
        start_rat_poision(path)
        
if __name__ == "__main__":
    main()