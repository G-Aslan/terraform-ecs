#!/bin/bash

# Use an appropriate base image for ARM64
FROM ubuntu:20.04

# Update package lists and install Apache2
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 && \
    rm -rf /var/lib/apt/lists/*

# Copy your HTML file to the Apache document root directory
COPY index.html /var/www/html/

# Expose port 80
EXPOSE 80

# Start Apache2 in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
