FROM ruby:2.6.5
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# Set the working directory to /myapp
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
# Copy the current directory contents into the container at /myapp
COPY . /myapp
# Add a script to be executed every time the container starts.COPY entrypoint.sh /usr/bin/
# RUN chmod +x ./entrypoint.sh
# ENTRYPOINT ["./entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
# CMD bundle exec puma -c config/puma.rb
# Start the main process. 
# Keep reading to see why we commented this line out! 
# CMD ["rails", "server", "-b", "0.0.0.0"]