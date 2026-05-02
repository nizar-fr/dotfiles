const fetchBtn = document.getElementById('fetch-btn');
const resultsDiv = document.getElementById('results');

fetchBtn.addEventListener('click', async () => {
  try {
    // Show loading state
    resultsDiv.innerHTML = '<p>Loading...</p>';

    // Fetch data from API (JSONPlaceholder)
    const response = await fetch('https://jsonplaceholder.typicode.com/posts?_limit=5');
    const posts = await response.json();

    // Clear loading state
    resultsDiv.innerHTML = '';

    // Display each post
    posts.forEach(post => {
      const postEl = document.createElement('div');
      postEl.classList.add('post');
      postEl.innerHTML = `
        <h3>${post.title}</h3>
        <p>${post.body}</p>
      `;
      resultsDiv.appendChild(postEl);
    });

  } catch (error) {
    resultsDiv.innerHTML = `<p class="error">Failed to fetch posts: ${error.message}</p>`;
  }
});
