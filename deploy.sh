
LOGFILE="deploy.log"

# הדפסת הודעה על התחלת התהליך
echo "Starting the deployment process..." >> $LOGFILE 2>&1

# שלב 1: בדיקת סטטוס Git
echo "Checking Git status..." >> $LOGFILE 2>&1
git status >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Error: git status failed!" >> $LOGFILE
    exit 1
fi

# שלב 2: הוספת כל השינויים (סטייג'ינג)
echo "Staging all changes..." >> $LOGFILE 2>&1
git add . >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Error: git add failed!" >> $LOGFILE
    exit 1
fi

# שלב 3: יצירת Commit עם הודעת אוטומטית
commit_message="Automated commit message"
echo "Committing changes with message: $commit_message" >> $LOGFILE 2>&1
git commit -m "$commit_message" >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Error: git commit failed!" >> $LOGFILE
    exit 1
fi

# שלב 4: Push ל-GitHub
echo "Pushing changes to GitHub..." >> $LOGFILE 2>&1
git push origin main >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Error: git push failed!" >> $LOGFILE
    exit 1
fi

# שלב 5: התקנת תלותים
echo "Installing dependencies..." >> $LOGFILE 2>&1
npm install >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Error: npm install failed!" >> $LOGFILE
    exit 1
fi

# שלב 6: בניית האפליקציה
echo "Building the app..." >> $LOGFILE 2>&1
npm run build >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Error: npm run build failed!" >> $LOGFILE
    exit 1
fi

# שלב 7: העלאת קבצים ל-GCS
echo "Uploading build to Google Cloud Storage (GCS)..." >> $LOGFILE 2>&1
gsutil -m cp -r /build/* gs://hadassah-react-app-bucket >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Error: gsutil upload failed!" >> $LOGFILE
    exit 1
fi

# הודעה על סיום ההפעלה
echo "Deployment process completed successfully!" >> $LOGFILE
