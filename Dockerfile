# Docker Container - 
# Description: Dockerfile for building a python appliation container.
#
# Usage: docker build -t <name> .
#        docker run -it <name>
#
FROM python:3.9.13-slim-bullseye AS builder

LABEL maintainer="Aaron C"
LABEL version="1.0"

# Update and install dependenciesß
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN python3 -m venv /opt/venv

# Set the ENV for PATH
ENV PATH="/opt/venv/bin:$PATH"

# Copy the requirements.txt file and contents from git
COPY requirements.txt .
COPY ./ ./

# Install the requirements
RUN pip3 install -r requirements.txt

# Build application from python script
RUN pyinstaller --onefile --clean --name app app.py

# Set executable permissions
RUN chmod +x /app/dist/app

# Copy the app to /usr/local/bin
RUN cp /app/dist/app /usr/local/bin/app

# Create a new container and pull in python application
FROM python:3.9.13-slim-bullseye

# Create user and group
RUN groupadd -r app && useradd --no-log-init -r -g app app

# Copy the application from the builder container
COPY --from=builder /usr/local/bin/app /usr/local/bin/app

# Set the user to app
USER app

# Set the working directory
WORKDIR /app

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/app"]