FROM node:alpine AS development

WORKDIR /usr/src/app

RUN npm install -g pnpm

COPY package.json ./

COPY pnpm-lock.yaml ./

RUN pnpm install

COPY . .

RUN pnpm run build

FROM node:alpine AS production

RUN npm install -g pnpm

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package.json ./

COPY pnpm-lock.yaml ./

RUN pnpm install --prod

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]
