# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installations
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    python3.6 \
    python3-pip \
    wget \
    git \
    && apt-get clean

# Install gcc-9 and g++-9
RUN apt-get update && apt-get install -y \
    gcc-9 \
    g++-9 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90


# Create a symlink to use 'python3' as 'python' (since python3.6 is the default)
RUN ln -s /usr/bin/python3.6 /usr/bin/python

# Install pybind11
RUN pip3 install pybind11

# Install C++14 compiler (gcc/g++)
RUN apt-get install -y gcc g++ 

# Set the default C++ standard to C++14
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90

# Verify installations
RUN g++ --version && cmake --version && python3 --version && pip3 show pybind11

# Clone and build pydnp3
RUN git clone --recursive http://github.com/Kisensum/pydnp3 && \
    cd pydnp3 && \
    python3 setup.py install


# Set the default working directory
WORKDIR /workspace

# Copy the master script into the workspace
COPY pydnp3_master.py /workspace/pydnp3_master.py

# Expose ports if necessary (for server use, if any)
EXPOSE 8080

# Command to keep the container running (replace with your desired command if necessary)
CMD ["/bin/bash"]
