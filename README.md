
# Objective

We would like to have you complete the following code test so we can evaluate your iOS skills. Please place your code in a public Github repository and commit each step of your process so we can review it.

Your assignment is to create a simple Reddit client that shows the top 50 entries from [Reddit]

## Project Structure 
 
-  #### Scenes
    This folder contains all view related elements like viewControllers, nib files. I used to create folder for each functionality/view i will work. For this specific case I create three view:
    PostDetails: To display the post detaills. Information comes from Post List cell selection.
    PostList: UIViewController with a UITableView to display the top 50 Reddit post. Also here you can find a custom cell for the table view using a nib with her respective controller.
    
    
-  #### Extensions
    Some common additons to native controllers to improve the behavior or functionalities. 
    
-  #### WebServices
    Here  you can find API handler files. API Service define where and how make the request, also the json parsing using an intermediate class to map the entire response and get next value for list posts call and post list. 
    
-  #### Models
    Data representation to map data coming for server into our environment. 

## What to show

The app should be able to show data from each entry such as:

- Title (at its full length, so take this into account when sizing your cells) :ok:
- Author :ok:
- entry date, following a format like “x hours ago” :ok:
- A thumbnail for those who have a picture. :ok:
- Number of comments :ok:
- Unread status :ok:

In addition, for those having a picture (besides the thumbnail), please allow the user to tap on the thumbnail to be sent to the full sized picture. You don’t have to implement the IMGUR API, so just opening the URL would be OK :ok:

## What to Include

- Pull to Refresh :ok:
    UIRefreshControl added manually to UITableView.

- Pagination support :ok:
    Supports pagination saving the after value included on get top reddit post response

- Saving pictures in the picture gallery :ok:
    Displays an alert when process complete or when process fails

- App state-preservation/restoration :ok:
    Implemented through shouldSave and shouldRestore app from appDelegate, and using Codable type alias

- Indicator of unread/read post (updated status, after post it’s selected) :ok:
    App a default value of read = false, when api mapping response. After user select a cell, it updates this value onl one time, avoiding unnnecesary re-renders.

- Dismiss Post Button (remove the cell from list. Animations required) :ok:
    Implemented using a custom protocol to inform about the user interaccion on the button.    

- Dismiss All Button (remove all posts. Animations required) :ok:

- Support split layout (left side: all posts / right side: detail post) :ok:
    I used split view native controller to support this requirement, connection the initial postListVC as the master view of the splitVC.


## Used Resources

- [Reddit API](http://www.reddit.com/dev/api)
- [Apigee](https://apigee.com/console/reddit) Broken url
- Example JSON file (top.json) is listed.
- Example Video of functionality is attached
