# Use the official SWI-Prolog image as the base
FROM swipl

# Install Python and pip
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip to the latest version (Not recommened to use break-system-packages flag)
RUN python3 -m pip install --upgrade pip --break-system-packages

RUN pip install janus-swi --break-system-packages

# Copy application files into the container
COPY . /app

# Set the working directory
WORKDIR /app

# Set the default command to run Prolog script
CMD ["swipl", "-s", "sample.pl"]
