#Start by pulling the amazonlinux latest image
FROM amazonlinux:latest

RUN yum -y install git
RUN yum -y install lsof
RUN yum groupinstall -y "Development Tools"
RUN yum install -y python-devel
RUN yum install -y python-pip

#Create a new directory nordcloud
RUN mkdir /nordcloud

#Clone git code of flask
WORKDIR /nordcloud
RUN git clone https://github.com/komarserjio/notejam.git

#Change the workdir to flask    
WORKDIR /nordcloud/notejam/flask

# Copy the runserver.py file into the image

COPY ../runserverlocal.py .


#Install the requirements.txt
RUN pip install -r requirements.txt
RUN pip install uwsgi
RUN amazon-linux-extras enable nginx1
RUN yum clean metadata
RUN yum -y install nginx

COPY ../uwsgi_socket/uwsgi.ini .
COPY ../uwsgi_socket/nginx.conf /etc/nginx/
COPY ../uwsgi_socket/startup.sh .

RUN chmod +x ./startup.sh

EXPOSE 8080

CMD [ "./startup.sh" ]
