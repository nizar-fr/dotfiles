// CSS Animation Triggers
document.getElementById('css-pulse-btn').addEventListener('click', () => {
  const box = document.querySelector('.css-animation-target');
  box.classList.toggle('pulse');
});

document.getElementById('css-spin-btn').addEventListener('click', () => {
  const box = document.querySelector('.css-animation-target');
  box.classList.toggle('spin');
});

// JS Animation Triggers (GSAP-like with requestAnimationFrame)
document.getElementById('js-move-btn').addEventListener('click', () => {
  const box = document.querySelector('.js-animation-target');
  let position = 0;
  const animate = () => {
    position += 5;
    box.style.transform = `translateX(${position}px)`;
    if (position < 100) requestAnimationFrame(animate);
  };
  animate();
});

document.getElementById('js-bounce-btn').addEventListener('click', () => {
  const box = document.querySelector('.js-animation-target');
  let scale = 1;
  const bounce = () => {
    scale = scale === 1 ? 1.2 : 1;
    box.style.transform = `scale(${scale})`;
    if (scale !== 1) setTimeout(bounce, 300);
  };
  bounce();
});
