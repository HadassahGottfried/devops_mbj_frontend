

# הדפסת הודעה על התחלת התהליך
echo "Starting the deployment process..."

# שלב 1: בדיקת סטטוס Git
echo "Checking Git status..."  
git status   
if [ $? -ne 0 ]; then
    echo "Error: git status failed!"  
    exit 1
fi

# שלב 2: הוספת כל השינויים (סטייג'ינג)
echo "Staging all changes..."    
git add .    
if [ $? -ne 0 ]; then
    echo "Error: git add failed!"   
    exit 1
fi

# שלב 3: יצירת Commit עם הודעת אוטומטית
commit_message="Automated commit message"
echo "Committing changes with message: $commit_message"    
git commit -m "$commit_message"    
if [ $? -ne 0 ]; then
    echo "Error: git commit failed!"   
    exit 1
fi

# שלב 4: Push ל-GitHub
echo "Pushing changes to GitHub..."    
git push origin main    
if [ $? -ne 0 ]; then
    echo "Error: git push failed!"   
    exit 1
fi

# שלב 5: התקנת תלותים
echo "Installing dependencies..."    
npm install    
if [ $? -ne 0 ]; then
    echo "Error: npm install failed!"   
    exit 1
fi

# שלב 6: בניית האפליקציה
echo "Building the app..."    
npm run build   
if [ $? -ne 0 ]; then
    echo "Error: npm run build failed!"  
    exit 1
fi

# שלב 7: העלאת קבצים ל-GCS
echo "Uploading build to Google Cloud Storage (GCS)..."   
gcloud storage cp ./build/* gs://hadassah-react-app-bucket   
if [ $? -ne 0 ]; then
    echo "Error: gcloud storage upload failed!"  
    exit 1
fi

# הודעה על סיום ההפעלה
echo "Deployment process completed successfully!"  
