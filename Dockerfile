FROM ruby:3.1.2

RUN apt-get update -qq\
	&& apt-get install -y build-essential libpq-dev nodejs\
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile* ./
RUN gem update --system
RUN gem install bundler
RUN bundle update
RUN bundle install
COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
