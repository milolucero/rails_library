# Dockerfile.rails
FROM ruby:3.1.2 AS rails-toolbox

# Default directory
WORKDIR /app

COPY . .

RUN apt-get update
# RUN apt-get upgrade -y

# Install other dependencies
RUN apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libpq-dev

# Install npm and yarn
RUN apt-get install -y npm
RUN npm install -y yarn

# Install Node
# RUN apt-get install -y nodejs
RUN npm install -g n
RUN n 18.13.0

COPY Gemfile .
COPY Gemfile.lock .

# Install rails
RUN gem install rails bundler

# Install gems
RUN bundle install

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]