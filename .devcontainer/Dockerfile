ARG VARIANT=focal
FROM ubuntu:${VARIANT}

COPY molecule/requirements.txt /tmp/molecule/requirements.txt
COPY requirements.txt /tmp/requirements.txt

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install curl git python3-dev python3-pip \
        python3-venv shellcheck sudo unzip docker.io jq \
    && curl -L \
        "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
        -o /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl \
    && python3 -m pip install pip --upgrade \
    && python3 -m pip install -r /tmp/molecule/requirements.txt

RUN useradd -s /bin/bash -m vscode && \
    usermod -aG docker vscode && \
    echo 'vscode ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/vscode && \
    echo 'source /etc/bash_completion.d/git-prompt' >> /home/vscode/.bashrc && \
    echo 'sudo chown vscode /var/run/docker-host.sock' >> /home/vscode/.bashrc && \
    echo 'export PS1="${PS1:0:-1}\[\033[38;5;196m\]$(__git_ps1)\[$(tput sgr0)\] "' >> /home/vscode/.bashrc

RUN ln -s /var/run/docker-host.sock /var/run/docker.sock

USER vscode
