# Tree-of-Life-Church-Inc-Non-Apple-Pay-Version

## Product Vision
FOR groups of friends or Office teams WHO want to plan a lunch event.(THE)
Devour is a social food browsing and recommendation service THAT provides
users a way to organize dinner plans with friends, colleagues, even family members taking everyone’s preferences in mind. UNLIKE Yelp, rather than being a
search tool, we offer suggestions to the customer, tailored to their preferred cuisine while also helping restaurants promote their business. UNLIKE seamless,
ubereats, grubhub, we do not focus on delivering the food to the customer and
we also don’t charge commissions to restaurants directly . This is attractive to
restaurants because the commission they pay to these delivery services is often
too high. Instead we will focus on charging a commision service from the delivery services directly where they in return will get more exposure to potential
new customers. OUR PRODUCT provides a social twist and exciting twist
on dining with friends.

## Software Priorities/Important Qualities

#### Software Compatibility 
Our app will prioritize Software Compatibility. This is because we want users to seamlessly interact with each other no matter which OS they are using. For vendors to utilize our user base our software will also need to be compatible with third party ordering and reservation apps. 

#### Security (Nonfunctional Product Characteristic)
Unlike zoom where anyone can enter any meeting our application will prioritize **security**. Our app has a table feature, similar to a lobby where friends can meet up before they decide on a restaurant to go out to. We want this feature to be secure, we don't want users to be able to view group chats or be apart of tables they didn't get invited to. 

#### Software Reuse
We are also prioritizing using APIs. Yes this means our software may be slower due to our app communicating with other API's however it will increase the production time and maintainability of our app because we do not mind creating functions around these APIs. 


![LayeredArchitecture](./READMEassets/LayeredArch.png)

## Technologies
- Database - MongoDB (NoSQL)
- Platform - It will be presented as a web platform.
- Server - Our application will communicate with a cloud server
- Open Source - Yelp API, we are limited to 5,000 API calls per 24 hours.
- Development Tools - MERN stack, due to our team's previous experiences 


## Dependancy Manager
start the program in the CMD by going into the backend folder and running:
```bash
'npm start'
```

## Group Members 
- Rumman Al 
- KarimDowon Lee
- John Solano
- William Ullauri
- Ivan Yatsko

# Docker
cd into frontend2 and run

```
docker pull davidullauri/devour
```

cd into backend and run

```
docker pull davidullauri/devour-backend
```

