function renderProductCard(product) {
  const card = document.createElement('div');
  card.className = 'col-4';

  const imageLink = document.createElement('a');
  imageLink.href = `productdetail.html?id=${product.id}`;

  const image = document.createElement('img');
  image.src = product.image;
  image.alt = product.name;
  imageLink.appendChild(image);
  card.appendChild(imageLink);

  const nameLink = document.createElement('a');
  nameLink.href = `productdetail.html?id=${product.id}`;
  const name = document.createElement('h4');
  name.textContent = product.name;
  nameLink.appendChild(name);
  card.appendChild(nameLink);

  const rating = document.createElement('div');
  rating.className = 'rating';
  for (let star = 0; star < 5; star += 1) {
    const icon = document.createElement('i');
    icon.className = star < product.rating ? 'fas fa-star' : 'far fa-star';
    rating.appendChild(icon);
  }
  card.appendChild(rating);

  const price = document.createElement('p');
  price.textContent = `$${Number(product.price).toFixed(2)}`;
  card.appendChild(price);
  return card;
}

async function loadProducts() {
  const containers = document.querySelectorAll('[data-product-list]');
  if (containers.length === 0) return;

  try {
    const response = await fetch('/api/products');
    if (!response.ok) throw new Error('The product service returned an error.');
    const products = await response.json();

    containers.forEach((container) => {
      const list = container.dataset.productList;
      const displayedProducts = list === 'featured'
        ? products.slice(0, 4)
        : list === 'latest'
          ? products.slice(4)
          : products;
      container.replaceChildren(...displayedProducts.map(renderProductCard));
    });
  } catch (error) {
    containers.forEach((container) => {
      const message = document.createElement('p');
      message.className = 'product-error';
      message.setAttribute('role', 'alert');
      message.textContent = 'Products could not be loaded. Please refresh the page and try again.';
      container.replaceChildren(message);
    });
    console.error('Unable to load products:', error);
  }
}

async function loadProductDetail() {
  const productImage = document.getElementById('ProductImg');
  if (!productImage) return;

  const productId = new URLSearchParams(window.location.search).get('id') || '1';
  const productHeading = document.querySelector('.single-product h1');
  const productPrice = document.querySelector('.single-product h4');

  try {
    const response = await fetch(`/api/product/${encodeURIComponent(productId)}`);
    if (!response.ok) throw new Error('The product service returned an error.');
    const product = await response.json();

    productHeading.textContent = product.name;
    productPrice.textContent = `$${Number(product.price).toFixed(2)}`;
    productImage.src = product.image;
    productImage.alt = product.name;
  } catch (error) {
    const message = document.createElement('p');
    message.className = 'product-error';
    message.setAttribute('role', 'alert');
    message.textContent = 'Product details could not be loaded. Please return to the product list and try again.';
    productPrice.insertAdjacentElement('afterend', message);
    console.error('Unable to load product details:', error);
  }
}

loadProducts();
loadProductDetail();
