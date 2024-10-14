# Digital Menu App

![Static Badge](https://img.shields.io/badge/Ruby-3.3.1-282828?style=flat&logo=ruby&logoColor=282828&labelColor=CC342D) ![Static Badge](https://img.shields.io/badge/RSpec-3.13-282828?style=flat&logo=rubygems&logoColor=282828&labelColor=f53e5c) ![Static Badge](https://img.shields.io/badge/Docker-27.3.1-282828?style=flat&logo=docker&logoColor=282828&labelColor=2496ED)

This is a Ruby on Rails application that provides functionality for managing restaurants, menus, and menu items. It allows restaurants to have multiple menus, and menu items can be associated with different menus within the same restaurant. Menu items are designed to avoid duplication.

## Features

- Restaurants can have multiple menus (e.g., lunch, dinner).
- Menu items can be shared between different menus of the same restaurant without duplication.
- RESTful API for managing restaurants, menus, and menu items.
- SQLite3 is used as the database for local development.
  
## Requirements

- [Docker](https://docs.docker.com/get-started/get-docker/) (_v20.10 or higher_)

## Setup Instructions

### 1. Clone the repository

```sh
git clone https://github.com/your-username/digital-menu-app.git
cd digital-menu-app
````

### 2. Build and Run the Application with Docker

Ensure that Docker is running on your machine, then follow these steps to build and start the application:

````sh
# Build the Docker image
docker compose build
````
````sh
# Create and migrate the database
docker compose run web rails db:create db:migrate
````
````sh
# Start the application
docker compose up
````

The application will be accessible at http://localhost:3000

### 3. Utilizing the application

You can find the API endpoints on Postman [here](https://www.postman.com/mission-astronomer-42266948/digital-menu-app/overview).

### 4. Running Tests

To run the test suite inside the Docker container, use the following command:

````sh
docker compose run web rspec
````

### Project Structure

- `app/models`: Contains the application’s models (Restaurant, Menu, MenuItem).
- `app/controllers`: Contains the controllers for handling requests to the API.
- `app/services`: Contains the logic to abstract and simplify usage on application.
- `spec`: Contains unit tests written in RSpec.
- 
### Development Notes

- The project is containerized with Docker for easy setup and deployment.
- The application uses SQLite3 for the local development database.
- A focus was placed on ensuring that menu items are not duplicated, even when associated with multiple menus.
