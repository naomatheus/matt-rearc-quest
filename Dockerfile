FROM node:10

# set environment variable
ENV SECRET_WORD="SOCK_PUPPET"

# copy contents of quest to container
COPY ./quest/ /

# manage permissions on custom binary files, all others should have exec permission
RUN chmod +x /bin/*

# install dependencies
RUN npm install

# expose ports used by application, <HOST>:<CONTAINER>
## use -p on commandline to publish
EXPOSE 3000:3000


# # run application
CMD ["npm","start"]