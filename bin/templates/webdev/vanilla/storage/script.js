// Tab System
document.querySelectorAll('.tab').forEach(tab => {
  tab.addEventListener('click', () => {
    document.querySelectorAll('.tab, .tab-content').forEach(el => {
      el.classList.remove('active');
    });
    tab.classList.add('active');
    document.getElementById(tab.dataset.tab).classList.add('active');
  });
});

// localStorage Operations
document.getElementById('local-save').addEventListener('click', () => {
  const key = document.getElementById('local-key').value;
  const value = document.getElementById('local-value').value;
  localStorage.setItem(key, value);
});

document.getElementById('local-read').addEventListener('click', () => {
  const output = document.getElementById('local-output');
  output.innerHTML = '';
  for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    output.innerHTML += `<p><strong>${key}:</strong> ${localStorage.getItem(key)}</p>`;
  }
});

// IndexedDB Setup (Simplified)
let db;
const request = indexedDB.open('InventoryDB', 1);

request.onupgradeneeded = (e) => {
  db = e.target.result;
  db.createObjectStore('items', { keyPath: 'name' });
};

request.onsuccess = (e) => {
  db = e.target.result;
};

document.getElementById('indexed-add').addEventListener('click', () => {
  const tx = db.transaction('items', 'readwrite');
  const store = tx.objectStore('items');
  store.add({
    name: document.getElementById('item-name').value,
    qty: document.getElementById('item-qty').value
  });
});

document.getElementById('indexed-get').addEventListener('click', () => {
  const output = document.getElementById('indexed-output');
  output.innerHTML = 'Loading...';
  const tx = db.transaction('items', 'readonly');
  const store = tx.objectStore('items');
  const req = store.getAll();
  
  req.onsuccess = () => {
    output.innerHTML = req.result.map(item => 
      `<p><strong>${item.name}:</strong> ${item.qty}</p>`
    ).join('');
  };
});
