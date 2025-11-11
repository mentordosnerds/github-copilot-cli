# Copilot CLI - Docker

This repository contains a `Dockerfile` to build a Docker image with the latest version of Node.js (v22+) and the GitHub Copilot CLI (`@github/copilot-cli`).

The goal is to allow the use of the Copilot CLI without the need to manage or change the Node.js version on your local machine.

## Automation with GitHub Actions

A GitHub Actions workflow is configured in `.github/workflows/docker-publish.yml` to automate the Docker image build and publication process.

The automation is triggered on the following events:
1.  **Push to the `main` branch**: On every new commit, the image is rebuilt and published with the `latest` and commit `SHA` tags.
2.  **Daily**: Every day, the workflow runs to ensure the `latest` image contains the most recent version of the `@github/copilot-cli` dependency, in case it has been updated on NPM.

The image is published to the GitHub Container Registry (ghcr.io) and can be found at:
`ghcr.io/mentordosnerds/github-copilot-cli`

## How to Use

To run the Copilot CLI using this Docker image, the command below is designed for a seamless experience, making the container behave as if the tool were running natively on your host.

It works by:
- Running the container with your current user ID to avoid file permission issues.
- Mapping your current directory into the container.
- Mapping your local `.config` directory to persist Copilot's authentication.
- Mapping your SSH agent socket and Git configuration to allow authentication with services like Git.

### Advanced Command

The `node` user in the container has its home at `/home/node`. We map host configurations to this directory.

```bash
docker run -it --rm --quiet --pull=always \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd):/work" \
  -w /work \
  -v "$HOME/.config:/home/node/.config" \
  -v "$HOME/.gitconfig:/home/node/.gitconfig:ro" \
  -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
  -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
  ghcr.io/mentordosnerds/github-copilot-cli:latest [COMMAND]
```
Replace `[COMMAND]` with the Copilot command you want to run (e.g., `auth`, `explain`, etc.).

**Note:** The SSH agent forwarding (`SSH_AUTH_SOCK`) will only work if your SSH agent is running and the environment variable is set.

### Alias for a Native Experience

For the best experience, create a shell alias. This will make the `copilot` command transparently execute the fully configured Docker container.

```bash
alias copilot='docker run -it --rm --quiet --pull=always \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd):/work" \
  -w /work \
  -v "$HOME/.config:/home/node/.config" \
  -v "$HOME/.gitconfig:/home/node/.gitconfig:ro" \
  -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
  -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
  ghcr.io/mentordosnerds/github-copilot-cli:latest'
```

#### How to make the alias permanent:

1.  Open your shell's configuration file (`~/.bashrc`, `~/.zshrc`, or `~/.config/fish/config.fish`).
2.  Add the alias line to the end of the file.
3.  Save the file and restart your terminal or run `source ~/.bashrc` (or the corresponding file) to apply the changes.

After setting up the alias, you can use the Copilot CLI as if it were installed locally, with your user permissions, SSH keys, and Git identity intact:
```bash
# Authenticate with GitHub (credentials will be saved in your local ~/.config)
copilot auth

# Use copilot to generate a commit message for your staged changes
git add .
copilot suggest -t git
```
