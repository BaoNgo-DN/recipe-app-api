FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

# The && in command lines is a logical AND operator used in Unix-like shell environments (like bash).
# It allows you to chain multiple commands together on a single line. 
# Key thing about && is that the second command (and any subsequent commands) will only execute if the preceding command is successful

# Line 12 and Line 16: default dev=false. if dev=true when running docker compose file, it will install dev.txt requirements.
# Line 17 -r /tmp/requirements.dev.txt:
# -r is an option for pip install that tells pip to install all the packages listed in a file.
#  /tmp/requirements.dev.txt is the path to the file that contains a list of Python packages that should be installed. 
#  Each line in this file typically specifies a package name and an optional version number.
# requirements.dev.txt has flake8 package which is a linter tool. 
