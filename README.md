
# 🔌 Integrating CORE with PowerWorld via DNP3 in a Dockerized Environment

This guide outlines the complete setup to enable communication between [CORE (Common Open Research Emulator)](https://www.nrl.navy.mil/itd/ncs/products/core) and [PowerWorld DS](https://www.powerworld.com/products/simulator) through a Dockerized DNP3 Master. This includes building the Docker container, configuring the DNP3 Master script, and launching emulated nodes that communicate over the DNP3 protocol.

---

## 🚀 Step-by-Step Instructions

### 🐳 1. Create and Start the Docker Container

- Use the provided `Dockerfile` to build a Docker image:

  ```bash
  docker build -t dnp3_container_image .
  ```

- Create and start a container from this image. **Give it a unique name** of your choice:

  ```bash
  docker run -dit --name <your_container_name> dnp3_container_image
  ```

> 🔖 _Note: Remember this container name for later steps._

---

### 🔐 2. Install OpenSSL Server Inside the Container

- Enter the container:

  ```bash
  docker exec -it <your_container_name> bash
  ```

- Install OpenSSL server:

  ```bash
  apt update && apt install -y openssh-server
  passwd root  # Set a password (you will use this in later scripts)
  service ssh start
  ```

---

### ⚡ 3. Configure PowerWorld DS

- On your **Windows machine**, open `PowerWorld Simulator` and load:

  - `Microgrid_PowerWorld.pwb` – the simulation file.
  - `Microgrid_PowerWorld.pwd` – the one-line diagram.

- Note the **IP address** of the Windows device running PowerWorld DS (you'll use it to configure the DNP3 master).

---

### 📝 4. Configure DNP3 Master Script

- Start the container again (if not already running):

  ```bash
  docker start <your_container_name>
  ```

- Inside the container, edit the IP address in `pydnp3_master.py`:

  ```python
  HOST = "PowerWolrdDS_Server_IP"  # Replace this with the actual IP
  ```

---

### 🧩 5. Integrate with CORE (Common Open Research Emulator)

- Copy the `docker.py` file into the following CORE directory on your host machine:

  ```
  /opt/core/venv/lib/python3.10/site-packages/core/nodes/
  ```

> ✅ _Ensure CORE is installed and activated properly._

---

### 🛠️ 6. Update Helper Scripts

- Open `test.sh` and modify the following:

  ```bash
  TARGET_NAME="<your_container_name>"
  ```

- Open `setup_and_connect.sh` and update:

  ```bash
  CONTAINER_NAME="<your_container_name>"
  SSH_PASSWORD="1"  # Replace with the password you set for root in Step 2
  ```

---

### 🌐 7. Launch CORE with Microgrid Topology

- Start CORE and load the topology file:

  ```
  Microgrid_CORE.xml
  ```

---

### 🔁 8. Final Execution

- Run `test.sh` with **root privilege** to distribute scripts to containers:

  ```bash
  sudo ./test.sh
  ```

- Open any CORE container, and run:

  ```bash
  ls
  ./setup_and_connect.sh
  ```

---

## ✅ Final Outcome

Your CORE containers are now configured to communicate with PowerWorld DS over the **DNP3 protocol** via the Dockerized master. This setup enables distributed real-time testing and interaction between simulated power systems and cyber infrastructure.

---

## 📌 Notes

- Ensure your firewall allows traffic between the CORE VM and the Windows machine.
- Verify that the DNP3 master is configured to match the DNP3 outstation settings in PowerWorld.

---

## 📂 File Structure

```
.
├── Dockerfile
├── pydnp3_master.py
├── docker.py
├── test.sh
├── setup_and_connect.sh
├── Microgrid_CORE.xml
├── Microgrid_PowerWorld.pwb
├── Microgrid_PowerWorld.pwd
└── README.md
```
