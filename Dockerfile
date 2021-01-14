FROM python:2.7-slim-buster
ENV LANG C.UTF-8
EXPOSE 8001
WORKDIR /app
ENV PYTHONPATH=/app

COPY . .
RUN /app/install_quiet.sh

RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

CMD ["sh", "-c", "python standalone.py 8001"]
