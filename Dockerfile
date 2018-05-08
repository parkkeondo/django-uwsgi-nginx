
FROM jmrose/nginx-python
MAINTAINER wkdal001@naver.com

ENV LANG C.UTF-8


# pyenv local설정
WORKDIR /home/docker/code/app
RUN pyenv local app

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/sites-available/default
COPY supervisor-app.conf /etc/supervisor/conf.d/

# COPY requirements.txt and RUN pip install BEFORE adding the rest of your code, this will cause Docker's caching mechanism
# to prevent re-installing (all your) dependencies when you made a change a line or two in your app.

COPY app/requirements.txt /home/docker/code/app/
RUN pip3 install -r /home/docker/code/app/requirements.txt

# add (the rest of) our code
COPY . /home/docker/code/

EXPOSE 80
CMD ["supervisord", "-n"]
