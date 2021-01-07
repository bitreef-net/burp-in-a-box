FROM debian

RUN apt-get update \
    && apt-get -y install build-essential wget openjdk-11-jdk

RUN useradd -m burp

USER burp
RUN mkdir -p /home/burp/bin

WORKDIR /home/burp/bin

# Install Burp Suite 
RUN wget -O ./burp.jar 'https://portswigger.net/DownloadUpdate.ashx?Product=Free' \
    && chmod +x ./burp.jar 

# This could be 1 RUN command by combining with the above but it is a waste of resources.  Pulling down and install Burp Suite just to change an alias or modify the echo does not make sense.
RUN echo '\nalias burp="java -jar /home/burp/bin/burp.jar"' >> ~/.bashrc \
    && echo '\necho "Welcome to Burp in a box!  To launch Burp Suite just run \"burp\""' >> ~/.bashrc

CMD ["bash", "-i"]
