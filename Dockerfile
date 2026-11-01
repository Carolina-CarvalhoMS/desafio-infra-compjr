FROM node:18-alpine

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --production --frozen-lockfile

COPY . .

USER node

EXPOSE 3000

CMD ["node", "src/index.js"]