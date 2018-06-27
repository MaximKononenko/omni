# Stage0
FROM maven:3.5.3-jdk-8 as builder

RUN mkdir -p /root/.ssh
COPY assets/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa && ssh-keyscan -H -t rsa bitbucket.org > /root/.ssh/known_hosts

#RUN git clone git@bitbucket.org:cameosaas/omnicore.git && \
#    git clone git@bitbucket.org:cameosaas/omniweb.git && \
#    git clone git@bitbucket.org:cameosaas/omniint.git

RUN git clone https://git@bitbucket.org/vladyslav_savko/omni2buildjdk8.git && \
    cd omni2buildjdk8/content && \
    javac HelloWorld/Main.java && \
    java -cp . HelloWorld.Main && \
    jar cfme Main.jar Manifest.mf HelloWorld.Main HelloWorld/Main.class

# COPY assets/settings.xml /root/.m2/
#RUN cd omnicore && mvn clean install -DskipTests=true
#RUN cd omniweb && mvn install -P PROD -DskipTests=true
#RUN cd omniint && mvn clean install -DskipTests=true

# Stage1
FROM alpine:3.7
RUN apk add --no-cache bash openjdk8

COPY --from=builder /omni2buildjdk8/content/Main.jar /root/

WORKDIR /root

EXPOSE 8080

CMD java -jar -Dspring.profiles.active=$ACTIVE_PROFILE Main.jar
