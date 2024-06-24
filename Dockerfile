FROM --platform=linux/amd64 node:20
WORKDIR /app

COPY package*.json ./
RUN npm install --only=production
COPY scripts /app
USER node
CMD ["node", "PullPushLiveStream.js"]
