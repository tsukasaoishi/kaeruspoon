FROM circleci/ruby:2.6.3-node-browsers

RUN sudo apt-get update && sudo apt-get install -y python3-pip
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/*

RUN sudo pip3 install awscli
