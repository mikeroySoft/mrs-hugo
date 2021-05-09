# start with an image that has the hugo binary installed
FROM mikeroysoft/hugo-builder:amd-v4 as site
# set the working directory so we have a consistent place
# the site will be built
WORKDIR /app
# copy the site contents into the image
COPY . /app
# running this command will build the site
RUN hugo

# start a new image based on the nginx container
FROM nginx:alpine
# copy the built site to the site directory
COPY --from=site /app/public /usr/share/nginx/html