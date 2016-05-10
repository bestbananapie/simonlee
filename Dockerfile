

#Set base image to Ubuntu
FROM ruby
MAINTAINER simonlee

ENV LANG C.UTF-8

RUN apt-get update -qq
RUN apt-get install -y nodejs

COPY ./jekyll/Gemfile* /tmp/
WORKDIR /tmp

RUN gem install bundler 

RUN bundle install

VOLUME src

WORKDIR /src

EXPOSE 4000

#ENTRYPOINT ["/bin/bundle","exec"]
ENTRYPOINT ["bundle","exec"]
CMD ["jekyll serve --port 4000 --host 0.0.0.0 --baseurl ''"]

