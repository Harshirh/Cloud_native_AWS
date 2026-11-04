# E-Commerce Website

This repository keeps the original HTML, CSS, JavaScript, and image assets, with a small Express API serving the site and its product catalog.

## Project structure

- `index.html`: home page with featured and latest product sections.
- `product.html`: full product listing page.
- `productdetail.html`: existing single product details page.
- `cart.html` and `Account.html`: existing cart and account pages.
- `style.css` and `images/`: shared styling and local website images.
- `frontend.js`: loads product data from the API on the home and listing pages.
- `backend/server.js`: Express API and static website server.
- `backend/products.json`: product catalog used by the API.

## Run locally

Install Node.js, then run these commands from the `backend` directory:

```sh
npm install
npm start
```

Fill `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` in `backend/.env` before starting. Keep the service role key in the backend only; `.env` is ignored by Git. Keep Row Level Security enabled on the `products` table. The backend uses its service role key to access the table.

The `products` table needs `id`, `name`, `price`, `rating`, and `image` columns. Run `npm run seed` from `backend` to upsert the existing catalog, preserving IDs.

Open `http://localhost:3000`. The API routes are `/api/health`, `/api/products`, `/api/product`, and `/api/product/:id`.
To use another port, change `PORT` in `backend/.env`.

## Build and run with Docker

Build the image from the project root:

```sh
docker build -t ecommerce-app:latest .
docker images
```

The Supabase credentials stay in `backend/.env` on the host and are passed to the container at startup. They are not copied into the image. The existing local server uses port 3000, so this command publishes the container on host port 3001:

```sh
docker run -d --name ecommerce-app -p 3001:3000 --env-file backend/.env ecommerce-app:latest
docker ps
docker logs -f ecommerce-app
```

Open `http://localhost:3001`. Check `http://localhost:3001/api/health`, `http://localhost:3001/api/products`, and `http://localhost:3001/productdetail.html?id=1`.

Stop and remove the container when finished:

```sh
docker stop ecommerce-app
docker rm ecommerce-app
```
