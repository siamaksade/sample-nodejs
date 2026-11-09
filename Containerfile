FROM registry.access.redhat.com/ubi9/nodejs-20-minimal@sha256:87f2eb0ce06e922a7629fa94fad62ed4e6be05931852b779269e0692282a099e

WORKDIR /opt/app-root/src

# Copy manifests first so dependency installation can be cached.
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Copy the Express application source.
COPY --chown=1001:0 . .

# Support OpenShift's arbitrary UID model.
RUN chgrp -R 0 /opt/app-root/src && chmod -R g=u /opt/app-root/src

ENV PORT=8080
EXPOSE 8080

USER 1001

CMD ["npm", "start"]