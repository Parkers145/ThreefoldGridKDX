KDX Docker Image for Ubuntu 22.04
Goal
The primary goal of this Docker image is to run KDX in the background of an Ubuntu 22.04 system and then serve the graphical user interface (GUI) of KDX to remote end users over SSH.

Overview
This setup allows you to run the KDX application on an Ubuntu 22.04 server while making its GUI accessible to remote users via SSH. The image leverages a combination of technologies and tools, including Docker, Zinit, and a set of initialization scripts to achieve this.

How It Works
Docker Image Configuration: The Dockerfile sets up the necessary environment, installs dependencies, and configures the system for running KDX. It includes installations of Node.js, Go, Rust, and NW.js, among other necessary libraries and tools.

Zinit for Service Management: Zinit is used to manage services and ensure they start in the correct order. The services include SSH daemon, D-Bus, and KDX itself.

Initialization Scripts:

start.sh: Prepares the environment by setting up necessary directories and permissions for SSH.
dbus.sh: Configures and starts the D-Bus service.
kdx-init.sh: Sets environment variables, starts a virtual display using Xvfb, and launches KDX.
ssh-monitor.sh: Monitors SSH connections and dynamically transfers the display output to the remote user's display upon connection, and reverts back when the connection is closed.
Zinit Service Definitions: YAML files in the zinit directory define how and when each service starts, ensuring the proper order and dependencies.

Repository Structure
Dockerfile: Defines the Docker image setup and configuration.
zinit:
sshd.yaml: Manages the SSH daemon.
sshd-init.yaml: Prepares SSH configuration.
dbus.yaml: Manages the D-Bus service.
kdx-init.yaml: Manages the initialization and running of KDX.
ssh-monitor.yaml: Monitors SSH connections.
scripts:
start.sh: Prepares SSH directories and permissions.
kdx-init.sh: Initializes and runs KDX.
ssh-monitor.sh: Monitors SSH connections and handles display transfers.
dbus.sh: Initializes and starts D-Bus.
Usage
To build and run the Docker image, follow these steps:

Build the Docker Image:

sh
Copy code
docker build -t kdx-image .
Run the Docker Container:

sh
Copy code
docker run -d --name kdx-container kdx-image
Access KDX GUI:

SSH into the container using an SSH client.
The KDX GUI will be forwarded to your local machine's display.
Conclusion
This Docker setup provides a streamlined way to run KDX on an Ubuntu 22.04 server and access its GUI remotely via SSH. By leveraging Zinit and custom initialization scripts, the setup ensures that all necessary services are started and managed correctly, providing a robust and flexible solution for remote GUI access.