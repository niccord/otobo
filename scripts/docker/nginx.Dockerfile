# This is the build file for the OTOBO nginx docker image.
# See also README_DOCKER.md.

# use the latest nginx
FROM nginx:mainline

# This setting work in the devel environment.
# In the general case DOCKER_HOST can be set when starting the container:
#   docker run -e DOCKER_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') -p 80:80 otobo_nginx
ENV DOCKER_HOST 172.17.0.1

# let nginx handle the static content
# The static files must be readable by the user nginx.
COPY --chown=nginx:nginx var/httpd/htdocs /usr/share/nginx/html/otobo-web

# move the old config out of the way
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.hidden


# new nginx config, will be modified by /docker-entrypoint.d/20-envsubst-on-templates.sh
# See 'Using environment variables in nginx configuration' in https://hub.docker.com/_/nginx
COPY scripts/nginx/otobo_nginx.conf.template /etc/nginx/templates/otobo_nginx.conf.template
