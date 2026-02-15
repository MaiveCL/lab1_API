//
// Helper pour encoder un objet en x-www-form-urlencoded
//
function toFormBody(obj) {
  return Object.keys(obj)
    .map(key => encodeURIComponent(key) + '=' + encodeURIComponent(obj[key]))
    .join('&');
}

//
// Créer un utilisateur (Devise attend form-urlencoded)
//
function apiRegister(email, password) {
  const body = toFormBody({
    'user[email]': email,
    'user[password]': password,
    'user[password_confirmation]': password,
    'authenticity_token': document.querySelector('meta[name="csrf-token"]').content
  });
  return fetch('/users', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body
  });
}

//
// Se connecter
//
function apiLogin(email, password) {
  const body = toFormBody({
    'user[email]': email,
    'user[password]': password,
    'authenticity_token': document.querySelector('meta[name="csrf-token"]').content
  });
  return fetch('/users/sign_in', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body
  });
}

//
// Mettre à jour le compte utilisateur (Devise exige current_password)
//
function apiUpdateUser(newEmail, currentPassword) {
  const body = toFormBody({
    'user[email]': newEmail,
    'user[current_password]': currentPassword,
    'authenticity_token': document.querySelector('meta[name="csrf-token"]').content
  });
  return fetch('/users', {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body
  });
}

//
// Supprimer le compte utilisateur
//
function apiDeleteUser(currentPassword) {
  const body = toFormBody({
    'user[current_password]': currentPassword,
    'authenticity_token': document.querySelector('meta[name="csrf-token"]').content
  });
  return fetch('/users', {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body
  });
}

//
// Déconnexion finale si nécessaire
//
function apiLogout() {
  const body = toFormBody({
    'authenticity_token': document.querySelector('meta[name="csrf-token"]').content
  });
  return fetch('/users/sign_out', {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body
  });
}

//
// Lister tous les produits
//
function apiListProducts() {
  return fetch('/products.json').then(r => r.json());
}

//
// Consulter un produit précis
//
function apiShowProduct(id) {
  return fetch(`/products/${id}.json`).then(r => r.json());
}

//
// Créer un produit
//
function apiCreateProduct({ name = "Produit JS", inventory_count = 3 } = {}) {
  return fetch('/products.json', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({ product: { name, inventory_count } })
  }).then(r => r.json());
}

//
// Update un produit
//
function apiUpdateProduct(id, { name } = {}) {
  return fetch(`/products/${id}.json`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({ product: { name } })
  }).then(r => r.json());
}

//
// Supprimer un produit
//
function apiDeleteProduct(id) {
  return fetch(`/products/${id}.json`, {
    method: 'DELETE',
    headers: { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content }
  });
}

//
// EXEMPLE COMPLET
//
document.addEventListener('DOMContentLoaded', async () => {
  const email = 'apiuser_' + Date.now() + '@example.com';
  const password = 'password123';

  console.log('=== Création utilisateur ===');
  await apiRegister(email, password);

  console.log('=== Connexion ===');
  await apiLogin(email, password);

  console.log('=== API publique (liste) ===');
  const products = await apiListProducts();
  console.log(products);

  console.log('=== Consultation publique d’un produit précis ===');
  if (products.length > 0) {
    console.log(await apiShowProduct(products[0].id));
  } else {
    console.log('Pas de produit public disponible');
  }

  console.log('=== Création produit ===');
  const p = await apiCreateProduct({ name: 'Produit Test', inventory_count: 5 });
  console.log(p);

  console.log('=== Update produit ===');
  await apiUpdateProduct(p.id, { name: 'Produit Test modifié' });

  console.log('=== Suppression produit ===');
  await apiDeleteProduct(p.id);

  console.log('=== Mise à jour du compte ===');
  const newEmail = 'updated_' + email;
  await apiUpdateUser(newEmail, password);

  console.log('=== Suppression du compte ===');
  await apiDeleteUser(password);

  console.log('=== Accès public après suppression du compte ===');
  const publicProducts = await apiListProducts();
  if (publicProducts.length > 0) {
    console.log(await apiShowProduct(publicProducts[0].id));
  } else {
    console.log('Pas de produit public disponible');
  }

  console.log('=== Terminé ===');
});
