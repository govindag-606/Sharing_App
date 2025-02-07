---

# Link Sharing - Data Sharing Platform

## Overview

Link Sharing is a data-sharing platform designed to facilitate the sharing of useful resources like links and documents within a community. Users can create topics, post resources, rate content, and subscribe to other topics. The platform supports both private and public sharing and offers admin control over user management and content moderation.

---

## Features

### User Management
- **Registration & Login**: Secure sign-up, login, and password reset functionality.
- **Profile Management**: Upload profile pictures, edit your username, and update your password.
- **User Deactivation**: Users can be deactivated by the admin (deactivated users cannot log in).

### Topics and Subscriptions
- **Create Topics**: Users can create unique topics (public or private).
- **Private Topics**: Requires an invitation to subscribe.
- **Public Topics**: Open for anyone to subscribe and view.
- **Unsubscribe**: Users can unsubscribe from topics they no longer wish to follow.
- **Topic Seriousness Levels**: Topics can be categorized into **SERIOUS**, **CASUAL**, and **VERY_SERIOUS** based on content depth.

### Content Sharing
- **Resource Sharing**: Users can share both link and document resources inside topics.
- **Search**: Search functionality to find specific topics, posts, and users.
- **Rating System**: Users can rate posts, with the top-rated posts appearing on the homepage.
- **Trending Topics**: Based on the highest number of subscriptions and interactions.

### Messaging & Notifications
- **Inbox System**: Users can send and receive private messages.
- **Message Notifications**: Unread message notifications with the ability to mark them as read.
- **Topic Invitations**: Users can invite others to private topics via email.

### Admin Controls
- **Content Management**: Admins can delete topics, posts, and resources.
- **User Management**: Admins can deactivate users, preventing login access.
- **Full Search Access**: Admins can search across all posts and topics.

### User Experience Enhancements
- **AJAX-based Search and Pagination**: For faster and more fluid navigation.
- **Responsive UI**: The platform is fully responsive and optimized for all devices.
- **Flash Messages**: Notifications for successful actions like create, update, or delete.

---

## Technologies Used 🛠️

### **Backend**  
- **Grails**: Web application framework used for rapid application development, combining Groovy and Java with Spring Boot.  
- **Groovy**: Dynamic language used in Grails for simplifying Java code.  
- **Java**: Core language used to implement backend functionality.  
- **Spring Boot**: For building and deploying the application as a standalone Java application.

### **Frontend**  
- **JavaScript (JS)**: For dynamic and interactive frontend development.  
- **AJAX**: Asynchronous JavaScript and XML used for updating parts of a webpage without reloading the entire page.  
- **jQuery**: JavaScript library that simplifies DOM manipulation and event handling.  
- **Bootstrap**: Frontend framework used for building a responsive and mobile-first design.  
- **GSP (Groovy Server Pages)**: Groovy-based templating engine used for generating dynamic HTML content.

### **Architecture & Design**  
- **MVC Architecture**: Implemented the Model-View-Controller pattern for better separation of concerns, improving code maintainability.  

### **Database**  
- **Oracle DB**: Relational database used to store and manage application data.  
- **SQLDeveloper**: Tool used for database management and querying Oracle databases.

### **Development Tools & Platforms**  
- **Git**: Version control system for tracking changes and collaborating on the codebase.  
- **Linux**: Operating system used for development and deployment.  
- **VirtualBox**: Used to set up isolated development environments.  

---

### Folder Structure
```
/link-sharing
│── /src
│   ├── /controllers
│   ├── /models
│   ├── /views
│── /public
│── config
│── README.md
│── requirements.txt
│── .gitignore
```

---


## Demo

For a quick demo of the platform's features, check out the following link:

[Watch the Demo](https://github.com/your-repo/demo-video-link)

---

## Additional Notes

- **"Learn Daily and Implement It"**: This platform is designed to encourage knowledge sharing and resource management.
- **Contributions**: If you have suggestions or improvements, feel free to **open a Pull Request (PR)**. Contributions are welcome!

---

**Happy Sharing and Learning!** 🎉

---
