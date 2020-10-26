FROM ruby:2.6-alpine

RUN apk update && apk upgrade

RUN apk add --no-cache \
  gcc \
  build-base \
  nodejs \
  npm \
  yarn \
  sqlite-dev

RUN mkdir /opt/application
WORKDIR /opt/application

ADD Gemfile /opt/application
ADD Gemfile.lock /opt/application

RUN yes | gem uninstall bundler --all && \
  export BUNDLER_VERSION=$(cat Gemfile.lock | tail -1 | tr -d " ") && \
  gem install bundler -v "$BUNDLER_VERSION"

# Do not install development or test gems in production
RUN if [ "$RAILS_ENV" = "production" ]; then \
  bundle install -j 4 -r 3 --without development test; \
  else bundle install -j 4 -r 3; \
  fi

# generate production assets if production environment
RUN if [ "$RAILS_ENV" = "production" ]; then \
  bundle exec rake assets:precompile; \
  fi
