# KDX Docker Image for Ubuntu 22.04

## Goal

The primary goal of this Docker image is to assess the possibility of running KDX in the background of an Ubuntu 22.04 system and then serve the graphical user interface (GUI) of KDX to remote end users over SSH.

## Overview

This setup allows you to run the KDX application on an Ubuntu 22.04 server while making its GUI accessible to remote users via SSH. The image leverages a combination of technologies and tools Zinit, and a set of initialization scripts to achieve this.

## How It Works

1. **Docker Image Configuration**: The Dockerfile sets up the necessary environment, installs dependencies, and configures the system for running KDX. It includes installations of Node.js, Go, Rust, and NW.js, among other necessary libraries and tools.

2. **Zinit for Service Management**: Zinit is used to manage services and ensure they start in the correct order. The services include SSH daemon, D-Bus, and KDX itself.

3. **Initialization Scripts**:
   - **start.sh**: Prepares the environment by setting up necessary directories and permissions for SSH.
   - **kdx-init.sh**: Sets environment variables, starts a virtual display using Xvfb, and launches KDX.
   - **ssh-monitor.sh**: Monitors SSH connections and dynamically transfers the display output to the remote user's display upon connection, and reverts back when the connection is closed.

4. **Zinit Service Definitions**: YAML files in the `zinit` directory define how and when each service starts, ensuring the proper order and dependencies.

## Repository Structure

- **Dockerfile**: Defines the Docker image setup and configuration.
- **zinit**:
  - **sshd.yaml**: Manages the SSH daemon.
  - **sshd-init.yaml**: Prepares SSH configuration.
  - **kdx-init.yaml**: Manages the initialization and running of KDX.
  - **ssh-monitor.yaml**: Monitors SSH connections.
- **scripts**:
  - **start.sh**: Prepares SSH directories and permissions.
  - **kdx-init.sh**: Initializes and runs KDX.
  - **ssh-monitor.sh**: Monitors SSH connections and handles display transfers.

## Usage

To build and run the Docker image, follow these steps:

1. **Build the Docker Image**:
   ```sh
   docker build 

2. **Run the Docker Container**:
   ```sh
   docker run 
   ```

3. **Access KDX GUI**:
   - SSH into the container using an SSH client.
   - The KDX GUI will be forwarded to your local machine's display.

## Conclusion

This Docker setup aims to provide a streamlined way to run KDX on an Ubuntu 22.04 server and access its GUI remotely via SSH. By leveraging Zinit and custom initialization scripts, the setup ensures that all necessary services are started and managed correctly, providing a robust and flexible solution for remote GUI access.
