FROM unityci/editor:2021.3.4f1-base-1
RUN apt-get update
RUN apt-get install -y default-jre libsaxonb-java
RUN apt-get install -y ca-certificates curl gnupg lsb-release
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce-cli 
RUN apt-get install -y npm
COPY scripts/ /scripts/
RUN chmod +x /scripts/unity-test.sh
