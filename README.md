# Docker Borg client

A client for [BorgBackup](https://www.borgbackup.org/) wrapped in a Docker container.

This container can be used to easily access Docker volumes to back up with Borg, using the [`--volumes-from`](https://docs.docker.com/engine/reference/commandline/container_run/#volumes-from) option of `docker run`.

# Usage

1. create the required directory structure:
    ```sh
    umask 077
    mkdir -p .ssh .config/borg .cache/borg
    ```

2. generate an SSH key for the client and put it in the `.ssh` directory:
    ```sh
    ssh-keygen -t ed25519 -C root@borg-client -f .ssh/id_ed25519 -N ""
    ```

    ⚠️⚠️ **WARNING** ⚠️⚠️ the `-N ""` option at the end will create an SSH key **without** a passphrase, which can be dangerous if you give full-access to this key on the server.

3. add the SSH key to the server:
    ```sh
    ssh-copy-id -i .ssh/id_ed25519.pub <user>@<hostname>
    ```

    ⚠️⚠️ **IMPORTANT** ⚠️⚠️ read [here](https://borgbackup.readthedocs.io/en/stable/usage/serve.html#examples) on how to secure this key on the server, **espescially if the key does not have a passphrase**

4. authenticate server's SSH key:
    ```sh
    ssh-keyscan <hostname> > .ssh/known_hosts
    ```
5. run the container
    ```
    docker run --rm \
        -v "$(pwd)/.ssh:/root/.ssh" \
        -v "$(pwd)/.config/borg:/root/.config/borg" \
        -v "$(pwd)/.cache/borg:/root/.cache/borg" \
        -e BORG_REPO=<repo URL> \
        rickysixx/borg-client:latest \
        <borg command>
    ```

    Replace `<repo URL>` with the URL to your Borg repository (see [here](https://borgbackup.readthedocs.io/en/stable/usage/general.html#repository-urls) for details) and `<borg command>` with the command you want to run (see [borg usage](https://borgbackup.readthedocs.io/en/stable/usage/general.html)).
