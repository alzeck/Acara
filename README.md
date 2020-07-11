![Logo](public/logo.png)

**Acara** is a website that allows its users to find and share events according to their preferences and location, managing their feed with the help of tags and followings, with the possibility to mark the partecipation and leave a comment.

**Acara** allows to look for and read the published events content and the registered users profiles, contact the developers and create an account.

If the user's already registered, **Acara** also offers the possibility to create, modify and interact with the events, manage their account, flag other content, ask for verification and receive a weekly report email.
A wide new world full of possibilities unfolds with Acara, where there are not just events, but real strong experiences and emotions.

You can try it live at https://acara.it

## Authors

- **Juan Sebastian Arboleda Polo, 1805920**
- **Andrea Cerone, 1770688**
- **Matteo Di Stadio, 1794111**


## Technologies used
- **Ruby on Rails** - for the base server, infrastructure and various gems
- **PostgreSQL** - relational database in which we save all data
- **Bootstrap** - to guarantee an adequate look & feel
- **Facebook Oauth** - for autenticating with Facebook into the site
- **Here Maps** - for maps and geocoding stuff
- **Sendgrid** - to handle emails
- **Redis Server** - to handle websockets
- **Linode** - in order to host the website
- **Swagger** - REST API documentation


## Dependencies
In order to build and run the Rails server in your machine, you must have already installed and configured:
- Ruby 2.7.0
- Rails 6.0.3.2
- Bundler 2.1.4
- Postgres >=11
- Yarn 1.22
- NodeJS (any version)
- Redis server (any version)
- ImageMagick 7


## Rails app setup

In order to successfully run the project, you have to obtain a valid API key on these services:
- [Facebook](https://developers.facebook.com/)
- [Here Maps](https://developer.here.com/)
- [SendGrid](https://sendgrid.com/)

To build and run the Rails app, go into the root folder of the repo and run the following commands:

- Build and install gems and js modules:
  ```sh
  Bundle install
  yarn install
  ```

- Save your API keys as enviroment variables: 
  ```sh
  export FACEBOOK_APP_ID='<your-facebook-app-id>'
  export FACEBOOK_APP_SECRET='<your-facebook-app-secret>'
  export SENDGRID_API_KEY='<your-sendgrid-api-key>'
  export HERE_API_KEY='<your-here-api-key>'
  ```
  Update [filters.js](app/assets/js/filters.js) and [maps.js](app/assets/js/maps.js) with your own here api keys
    ``` javascript
    var platform = new H.service.Platform({
       'apikey': "<your-here-api-key>"
    });
    ```
  If you are planing on deploying this app read the **Deployment** section

- With postgresql service running inizialize the database:

  ```sh
  rake db:setup
  ```
  
## Rails app usage

After the first setup, execute these commmands to start the server:

* With Redis service running, start the rails server:
  ```sh
  rails server
  ```

  You will find your running instance of acara at https://localhost:3000
  
  
## REST API
This application also provides some **REST API** methods. For all the available api methods, an **API KEY** is needed, in order to increase security and reliability. An API KEY is granted to a **registered verified user** and can be accessed in their **settings**.

These api are well documented on Swagger and can be viewed at [Swaggerhub](https://app.swaggerhub.com/apis/matteo-ds/Acara/1.0.0)

AVAILABLE API METHODS:
- Receive a list of all users
- Search for a specific user
- Receive a list of all events
- Create an event
- Search for a specific event
- Update a specific event
- Delete a specific event
- Receive a list of all the comments of an event
- Create a comment for an event
- Search for a specific comment of an event
- Update a specific comment of an event
- Delete a specific comment of an event


## Testing
This project also includes three test cases (with one specific to the APIs) to test the main functions of the website from both a view and unity level, using the Rails gems Cucumber, Capybara, RSpec, FactoryBot and Rake_session_access

- Update an event
- Leave a comment
- Receive a list of all users with APIs

To launch them all with Cucumber and Capybara, run in the main directory:
  ```sh
  rake cucumber
  ```

To launch them all with RSpec, FactoryBot and Rake_session_access, run in the main directory:
  ```sh
  bundle exec rspec ./spec/*_spec.rb
  ```


## Deployment

1. Install the dependencies, plus [passenger](https://www.phusionpassenger.com/),  we recommend using it in combination with nginx.

    You will need to set up SSL certificates, to use this app. 

2. Set up your deployment user and save the api keys as environment variables (usually it can be done adding them to `.profile`) and also your database url
    ```sh
    export DATABASE_URL="postgresql://USER:PASSWORD@127.0.0.1/DATABASE_NAME"
    ```

3. Edit [deploy.rb](config/deploy.rb) and [production.rb](config/deploy/production.rb) to match with your server info

4. Run on your local machine
    ```sh
        cap production deploy
    ```

For more information you can consult this [GoRails Guide](https://gorails.com/deploy/ubuntu/18.04)

## Known issues
- On the production server, **continue with facebook** might fail to create an account, you can keep on clicking it till it works 
- SendGrind is known to not deliver emails for some email services like:
  - hotmail.com
  - alice.it
  - virgilio.it
