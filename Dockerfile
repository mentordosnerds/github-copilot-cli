# Use an official Node.js base image (v22 or higher)
# The Alpine version is smaller and recommended for production
FROM node:22-alpine

# Define the image author (optional)
LABEL maintainer="Felipe Sayão Lobato Abreu <github@mentordosnerds.com>"

# Add a build argument to bust the cache
ARG CACHE_BUSTER

# Install the GitHub Copilot CLI globally
# Node 22 already comes with npm v10+, so no extra step is needed
RUN npm install -g @github/copilot

# Set the default working directory for when the container runs
WORKDIR /work

# Set the entrypoint to execute the Copilot CLI
# This allows you to pass commands directly to copilot
# Ex: docker run ... copilot --help
ENTRYPOINT ["copilot"]

# The default CMD can be a help command to guide the user
CMD ["--help"]
