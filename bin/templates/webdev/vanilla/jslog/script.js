function log(message) {
  const container = document.getElementById('log-container');
  const entry = document.createElement('div');
  entry.className = 'log-entry';
  entry.innerHTML = message;
  container.appendChild(entry);
  container.scrollTop = container.scrollHeight; // Auto-scroll
}

const originalLog = console.log;

console.log = function(...args){
  originalLog(...args);
  log(...args);
}

console.log("Something");
