# session.sh
# Use this file to track the commands that you execute in your terminal.
# You probably need more commands than what is suggested here.
# Just list these in the appropriate place below.

# Print your working directory
pwd

# Change your directory to a folder in which you do work for this class
# Make sure to use the "~" shortcut rather than specifying the full path
cd ~/Desktop/"INFO 201"/"Assignments"

# Clone your private assignment repository from GitHub to your machine
git clone https://github.com/info201b-au17/a1-md-rioishii.git

# Change your directory to inside of your "a1-news-USERNAME" folder
cd "a1-md-rioishii"

# Make a new folder called "imgs" - you'll download an image into this folder
mkdir "imgs"

# At appropriate checkpoints, you'll need to do the following:
# Add all of your changes that you've made to git
git add "security.jpg"
git add "README.md"
git add "session.sh"

# Make a commit, including a descriptive message
git commit -m "Created a simple markdown page for a news article. 
Includes a introductry paragraph summarizing the event, relevant image, 
and unordered list of additional information with hyperlinks"

# Push your change up to GitHub
git push

# See status
git status
