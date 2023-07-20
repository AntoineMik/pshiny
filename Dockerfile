# FROM python:3.9-slim
FROM polusai/notebook:0.9.11

# Set working directory
WORKDIR /usr/local/pshiny

# Copy the relevant files
COPY ./pshiny .
COPY ./common ./

# Install requirements
RUN pip3 install --no-cache-dir --upgrade  -r requirements.txt

# Use the root user to run the change to the revelant permissions
USER root
RUN apt-get update && \
    apt-get install -y jq
RUN mkdir -p /usr/local/pshiny/app && \
    chown $NB_USER:$NB_GID /usr/local/pshiny/app
RUN chmod +x /usr/local/pshiny/pshiny-wrapper.sh
# Move the application file to the user directory
RUN mv app.py /usr/local/pshiny/app

# create a user, since we don't want to run as root
# RUN useradd -m jovyan
ENV HOME=/home/jovyan
# WORKDIR $HOME
USER jovyan

ENV WORKDIR=/usr/local/pshiny/app

# Set entrypoint
ENTRYPOINT /usr/local/pshiny/pshiny-wrapper.sh
