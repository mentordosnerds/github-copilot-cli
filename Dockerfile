# Stage 1: Base with a potentially cached installation
FROM node:22-slim AS base
# Install the CLI. This layer is cached and serves as a starting point.
RUN npm install -g @github/copilot

# Stage 2: Updater to fetch the latest version
FROM base AS updater
# This ARG invalidates the cache for this stage, forcing the update to run
ARG CACHE_BUSTER
RUN npm update -g @github/copilot

# Final Stage: Create a clean, final image from the slim base
FROM node:22-slim
LABEL maintainer="Felipe Sayão Lobato Abreu <github@mentordosnerds.com>"

# Set the default working directory for when the container runs
WORKDIR /work

# Set the entrypoint to execute the Copilot CLI
ENTRYPOINT ["copilot"]

# The default CMD can be a help command to guide the user
CMD ["--help"]

# Copy the updated files from the 'updater' stage using --link
# --link can optimize layer usage by linking unchanged files from previous layers
COPY --from=updater --link /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=updater --link /usr/local/bin /usr/local/bin
