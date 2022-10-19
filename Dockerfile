FROM node:16.17-alpine

RUN mkdir -p /usr/src/node
WORKDIR /usr/src/node
COPY . /usr/src/node

RUN npm install -g npm@8.19.2 && \
    npm install && \
    npm install -g typescript && \
    tsc

EXPOSE 8081
CMD ["npm", "run", "pro"]