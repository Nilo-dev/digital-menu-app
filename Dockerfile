# Dockerfile

# Use the official Ruby image based on Alpine Linux
FROM ruby:3.3.1-alpine

# Install required dependencies, including build tools
RUN apk add --no-cache build-base curl nodejs yarn sqlite-dev tzdata

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install Ruby gems specified in the Gemfile
RUN bundle install

# Copy the entire application code to the container's working directory
COPY . .

# Expose port 3000 to allow external access to the Rails app
EXPOSE 3000

# Set the default command to start the Rails server, accessible on all network interfaces
CMD ["rails", "server", "-b", "0.0.0.0"]
