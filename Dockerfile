# Dockerfile.rails
FROM ruby:3.1.4-alpine3.18 AS rails-toolbox

# Default directory
WORKDIR /app

COPY . .

RUN apk update

# Install other dependencies
RUN apk add zlib-dev build-base openssl-dev readline-dev yaml-dev sqlite-dev sqlite libxml2-dev libxslt-dev curl-dev libffi-dev postgresql-dev

# Install npm and yarn
RUN apk add --update nodejs npm
RUN npm install yarn

# Install bash (required for n package)
RUN apk add bash

# Install Node
RUN npm install -g n
RUN n 18.13.0

COPY Gemfile .
COPY Gemfile.lock .

# Install rails
RUN gem install rails bundler

# Install gems
RUN bundle install

# Stripe keys
ENV PUBLISHABLE_KEY=$PUBLISHABLE_KEY
ENV SECRET_KEY=$SECRET_KEY

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

# Sample build and run commands
# docker build -t milolucero/rails_library:1.0 .
# docker run --env-file .env -it --rm -p 3000:3000 milolucero/rails_library:1.0