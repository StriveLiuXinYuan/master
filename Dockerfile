FROM python:2.7-slim-buster
ENV LANG C.UTF-8
EXPOSE 8001
WORKDIR /app
ENV PYTHONPATH=/app

RUN sed -i 's#http://archive.ubuntu.com#http://mirrors.163.com#g' /etc/apt/sources.list && \
    sed -i 's#http://security.ubuntu.com#http://mirrors.163.com#g' /etc/apt/sources.list && \
    apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget curl nano mime-type

COPY . .
RUN /app/install_quiet.sh

RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

CMD ["sh", "-c", "python standalone.py 8001"]
