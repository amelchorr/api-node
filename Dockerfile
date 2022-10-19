FROM node:16.17

RUN mkdir -p /usr/src/node
WORKDIR /usr/src/node
COPY . /usr/src/node

RUN npm install -g npm@8.19.2
RUN npm install

RUN npm install -g typescript
RUN tsc

EXPOSE 8081
CMD ["npm", "run", "pro"]