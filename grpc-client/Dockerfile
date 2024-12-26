FROM ubuntu:22.04

RUN apt-get update -y && \
    apt-get install -y wget tar jq && \
    apt-get clean

RUN wget https://github.com/fullstorydev/grpcurl/releases/download/v1.9.2/grpcurl_1.9.2_linux_x86_64.tar.gz && \
    tar -xvzf grpcurl_1.9.2_linux_x86_64.tar.gz && \
    chmod +x grpcurl && \
    mv grpcurl /usr/local/bin/grpcurl

COPY run_tests.sh .
RUN chmod +x ./run_tests.sh
