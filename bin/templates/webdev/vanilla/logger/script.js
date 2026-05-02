class BrowserLogger {
  constructor() {
    this.logs = [];
    this.currentLevel = 'all';
    this.filterText = '';
    this.persist = false;
    
    this.initStorage();
    this.setupListeners();
    this.overrideConsole();
    this.renderLogs();
    
    // Load persisted logs if enabled
    if (this.persist && localStorage.getItem('js-logs')) {
      this.logs = JSON.parse(localStorage.getItem('js-logs'));
      this.renderLogs();
    }
  }
  
  initStorage() {
    const persistToggle = document.getElementById('persist-logs');
    this.persist = localStorage.getItem('js-logger-persist') === 'true';
    persistToggle.checked = this.persist;
    
    persistToggle.addEventListener('change', (e) => {
      this.persist = e.target.checked;
      localStorage.setItem('js-logger-persist', this.persist);
    });
  }
  
  setupListeners() {
    document.getElementById('clear-logs').addEventListener('click', () => {
      this.logs = [];
      this.saveLogs();
      this.renderLogs();
    });
    
    document.getElementById('log-filter').addEventListener('input', (e) => {
      this.filterText = e.target.value.toLowerCase();
      this.renderLogs();
    });
    
    document.querySelectorAll('.log-levels button').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelector('.log-levels button.active').classList.remove('active');
        btn.classList.add('active');
        this.currentLevel = btn.dataset.level;
        this.renderLogs();
      });
    });
    
    // Demo buttons - Remove in production
    document.getElementById('demo-log').addEventListener('click', () => {
      console.log('This is a test log message', { foo: 'bar' });
      console.info('Informational message');
      console.warn('Warning: Something might be wrong');
      console.error('Error: Something broke!');
    });
    
    document.getElementById('demo-error').addEventListener('click', () => {
      try {
        throw new Error('Test error stack trace');
      } catch (e) {
        console.error(e);
      }
    });
  }
  
  overrideConsole() {
    const original = {
      log: console.log,
      info: console.info,
      warn: console.warn,
      error: console.error
    };
    
    const handler = (type) => (...args) => {
      // Call original console method
      original[type](...args);
      
      // Format log entry
      const timestamp = new Date().toISOString();
      const message = args.map(arg => {
        if (typeof arg === 'object') {
          try {
            return JSON.stringify(arg, null, 2);
          } catch {
            return arg.toString();
          }
        }
        return arg;
      }).join(' ');
      
      this.logs.push({
        type,
        message,
        timestamp,
        stack: type === 'error' ? new Error().stack : null
      });
      
      this.saveLogs();
      this.renderLogs();
    };
    
    console.log = handler('log');
    console.info = handler('info');
    console.warn = handler('warn');
    console.error = handler('error');
  }
  
  saveLogs() {
    if (this.persist) {
      localStorage.setItem('js-logs', JSON.stringify(this.logs));
    }
  }
  
  renderLogs() {
    const output = document.getElementById('log-output');
    const filtered = this.logs.filter(log => {
      const levelMatch = this.currentLevel === 'all' || log.type === this.currentLevel;
      const textMatch = log.message.toLowerCase().includes(this.filterText);
      return levelMatch && textMatch;
    });
    
    output.innerHTML = filtered.map(log => `
      <div class="log-entry ${log.type}">
        [${log.timestamp}] ${log.type.toUpperCase()}: ${log.message}
        ${log.stack ? `<div class="stack">${log.stack}</div>` : ''}
      </div>
    `).join('');
    
    output.scrollTop = output.scrollHeight;
  }
}

// Initialize
new BrowserLogger();
