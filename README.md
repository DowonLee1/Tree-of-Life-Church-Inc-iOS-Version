# Tree-of-Life-Church-Inc-Non-Apple-Pay-Version

![1aa](https://user-images.githubusercontent.com/25316124/119722043-e0458d80-be39-11eb-9517-f302e4c270e5.jpg)
![1bb](https://user-images.githubusercontent.com/25316124/119722056-e2a7e780-be39-11eb-8781-4dd22f0b0ca0.jpg)
![c](https://user-images.githubusercontent.com/25316124/119722180-05d29700-be3a-11eb-8967-77f843c85315.jpg)
![d](https://user-images.githubusercontent.com/25316124/119722196-09661e00-be3a-11eb-9c78-4fe6f3545bca.jpg)


## Product Vision
You can find sermon channels divided into 5 languages and sermons you want by category. You can also easily browse missionary videos. You can easily view all church information and events. We support online donations or offering in environments where it is difficult to attend worship services directly due to COVID-19, and support a mobile translation system that will replace the use of a direct translation device. In addition, sermons can be easily mirrored and viewed on a smart TV.

## Technologies
- Database - Firebase(NoSQL)
- Platform - Ios, Android(In Progress)
- Server - Firebase cloud server
- Open Source - Youtube API
- Development Tools - Xcode, Sketch(UI/UX), iMovie(Video Editing)

## All Developed By Dowon Lee
- Front-End by Dowon
- Back-End by Dowon
- UI/UX by Dowon
- Design by Dowon
- Video Edit by Dowon

## Develop History

## Handling Video(Sermons) Contents

At the time of initial development, all video content of the church was stored on the YouTube site.  At this point, I thought there was no need to spend more money and run another server, so I decided to use the YouTube API.  This is because, if you use the YouTube API, you can maximize cost reduction and easy management.  It was decided to use the framework by extracting only YouTube video frames.

## Handling REAL-Time Database Server

Considering the characteristics of the church in the initial development stage, I felt the need for a Real-Time Database because new contents were added every day or every week.  Because there was a limit to running the server 24 hours a day, we decided to use an external server and decided to use Google's Firebase.  Although there were choices of other platforms such as AWS and MongoDB, I chose Firebase because it has advantages for small and medium-sized management.  

Firebase's NoSql format brought many advantages in terms of data management. I was not bound by the format and was able to modify it without any problem even if there was an additional point of data format.  Except for technical updates, everything was developed to be done on the server.

## Handling Live Streaming Detection

When a church runs a live streaming sermon on YouTube, there are several factors that the app can detect.  In the case of live streaming, we found that the duration was 14 seconds or 0 seconds.  If the duration of the video is 14 seconds or 0 seconds when the video is played, it is coded to display a live streaming sign.

## Handling Live Translation Channels (4 Channels)

The Live Translation function, one of the characteristics of this church, was also implemented in mobile. This church was using a Translation Device.  The machine simply served as an interpreter to translate and deliver it to people.  Considering minimal contact through the Covid-19 period, it was the best way to implement it on mobile.  In this process, we decided to use the Youbut API without choosing to use any additional equipment. 

The advantage of this process is that it is easy to handle.  In this process, only sound can be transmitted.  Since Live Translation should only work in the Live environment, the duration of the video was detected in this process as well.  It was made to be executed only when the duration of the video was 14 or 0 seconds.

## Handling Online Donation Or Offering (Apple pay)

Due to the Covid-19 period, there was a need for online donations. In this case, it was built so that you can easily donate or offer through Apple Pay. Apple Pay was implemented using Apple's Passkit, but in the end, it was decided to implement as a later update due to various payment process problems.

## Handling UI/UX Design

The most important point when implementing UI/UX was the neatness of the design and the easy-to-use experience. The priority was to divide the process into a minimum number of processes so that users do not get lost.  In the case of sermons, the sermons were divided into 5 languages ​​+ missionary videos, and the sermons for each language were classified by classification to make them easier to access.  In the case of the main page, important functions are placed at the bottom of the screen and important information is placed in the center of the screen.  

Also, in the case of images, NSCache data is used so that when the same image comes out, it can be displayed through quick access without downloading it again.  In addition, the minimum management cost was selected by using Google Drive rather than storing it in Google Firebase. Because in the case of Google Firebase, if you use more than 1GB of data, you pay monthly.

## Handling time complexity (Big-0 notation) for sorting data 

When sorting data in the database, it is sorted by date. The first reason for not using the timestamp was because it was complicated to manually find data on the server, and the second was because there were already 2-3 years of data on YouTube in the early stages of development.When an app requests data from the server, the largest number is the last request. For example, it should be sorted by newest, but it was sorted by oldest. In this case, it is O(n^2) instead of O(n) when considering time complexity because data needs to be sorted again in the array after parsing.  

In this case, after considering the characteristics of the data being reversed, I started organizing with the opposite concept. In other words, "-" was added in front of the date number to make it a negative number. After converting the date to negative, the data could be sorted in the latest order without a separate sorting.


