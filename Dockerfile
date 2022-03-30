FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu60 \
    libunwind8 \
    netcat \
    libssl1.0 \
    maven \
    time \
    unzip \
    wget \
    zip \
    tzdata \
    apt-utils \
    apt-transport-https \
    xvfb \
    sudo \
    nodejs \
    gnupg-agent \
    software-properties-common \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/*

  RUN curl https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb > packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \
  && rm packages-microsoft-prod.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
     apt-transport-https \
     dotnet-sdk-2.1 \
     dotnet-sdk-3.1 \
     dotnet-sdk-5.0 \
     dotnet-sdk-6.0 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/*

RUN dotnet help
ENV dotnet=/usr/bin/dotnet  

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]