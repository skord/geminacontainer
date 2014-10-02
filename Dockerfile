FROM phusion/passenger-full:0.9.13
ENV HOME /root
COPY nginx.conf /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down
RUN gem install geminabox
RUN mkdir -p /home/app/geminabox &&\
    mkdir -p /home/app/geminabox/public &&\
    mkdir -p /home/app/geminabox/tmp &&\
    mkdir -p /data/geminabox-data &&\
    chown -R app:app /home/app &&\
    chown app:app /data/geminabox-data
COPY envs.conf /etc/nginx/main.d/envs.conf
COPY config.ru /home/app/geminabox/config.ru
