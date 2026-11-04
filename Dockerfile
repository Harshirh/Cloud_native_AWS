FROM node:24-alpine

ENV NODE_ENV=production \
    PORT=3000

WORKDIR /app/backend

COPY backend/package.json backend/package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

WORKDIR /app

COPY --chown=node:node index.html product.html productdetail.html cart.html Account.html style.css frontend.js ./
COPY --chown=node:node images/ ./images/
COPY --chown=node:node backend/server.js ./backend/server.js
COPY --chown=node:node backend/config/ ./backend/config/

EXPOSE 3000

USER node
WORKDIR /app/backend

CMD ["npm", "start"]
