FROM debian:jessie

# Add Jenkins user
ENV HOME /home/jenkins
RUN groupadd -g 10000 jenkins
RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins


# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
				x11-utils \
				x11-xserver-utils \
		&& rm -rf /var/lib/apt/lists/*



#Add Jenkins workspace
ENV JENKINS_WORKSPACE /var/jenkins_workspace
VOLUME /var/jenkins_workspace
RUN chown -R jenkins "$JENKINS_WORKSPACE"

# start x11vnc and expose its port
ENV DISPLAY :0.0
EXPOSE 5900
EXPOSE 6000
EXPOSE 6001
EXPOSE 6002
EXPOSE 6003
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# switch to user and start
USER jenkins
ENTRYPOINT ["/entrypoint.sh"]
