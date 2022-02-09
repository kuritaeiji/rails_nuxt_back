FROM ruby:2.7.1

RUN apt-get update
RUN apt-get install -y build-essential default-mysql-client
RUN apt-get install -y nodejs npm
RUN npm install n -g
RUN n stable
RUN apt purge -y nodejs npm
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -y install yarn

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app

# herokuのために追加
COPY . /app
# ここまで

RUN bundle config set path 'vendor/bundle'
RUN bundle install

# herokuのために追加
RUN bundle exec rails db:migrate
CMD [ "bundle", "exec", "puma", "-C", "config/puma.rb" ]