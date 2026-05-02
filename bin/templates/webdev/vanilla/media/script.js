// Custom Video Player
const video = document.getElementById('custom-video');
const playBtn = document.getElementById('play-btn');
const volume = document.getElementById('volume');
const timeDisplay = document.getElementById('time');

playBtn.addEventListener('click', () => {
  if (video.paused) {
    video.play();
    playBtn.textContent = '❚❚';
  } else {
    video.pause();
    playBtn.textContent = '▶';
  }
});

volume.addEventListener('input', () => {
  video.volume = volume.value;
});

video.addEventListener('timeupdate', () => {
  const minutes = Math.floor(video.currentTime / 60);
  const seconds = Math.floor(video.currentTime % 60);
  const totalMinutes = Math.floor(video.duration / 60);
  const totalSeconds = Math.floor(video.duration % 60);
  
  timeDisplay.textContent = 
    `${minutes}:${seconds.toString().padStart(2, '0')} / 
     ${totalMinutes}:${totalSeconds.toString().padStart(2, '0')}`;
});

// Audio Visualizer
const audioUpload = document.getElementById('audio-upload');
const canvas = document.getElementById('visualizer');
const ctx = canvas.getContext('2d');

let audioContext, analyser, dataArray;

audioUpload.addEventListener('change', (e) => {
  const file = e.target.files[0];
  const audio = new Audio(URL.createObjectURL(file));
  
  audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const source = audioContext.createMediaElementSource(audio);
  analyser = audioContext.createAnalyser();
  analyser.fftSize = 256;
  
  source.connect(analyser);
  analyser.connect(audioContext.destination);
  
  dataArray = new Uint8Array(analyser.frequencyBinCount);
  audio.play();
  drawVisualizer();
});

function drawVisualizer() {
  requestAnimationFrame(drawVisualizer);
  analyser.getByteFrequencyData(dataArray);
  
  ctx.fillStyle = '#111';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  
  const barWidth = (canvas.width / dataArray.length) * 2.5;
  let x = 0;
  
  dataArray.forEach(value => {
    const barHeight = value;
    ctx.fillStyle = `hsl(${value}, 100%, 50%)`;
    ctx.fillRect(x, canvas.height - barHeight, barWidth, barHeight);
    x += barWidth + 1;
  });
}

// Webcam Capture
const cameraBtn = document.getElementById('camera-btn');
const cameraFeed = document.getElementById('camera-feed');
const captureBtn = document.getElementById('capture-btn');
const snapshot = document.getElementById('snapshot').getContext('2d');

cameraBtn.addEventListener('click', async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true });
    cameraFeed.srcObject = stream;
  } catch (err) {
    console.error("Camera error:", err);
  }
});

captureBtn.addEventListener('click', () => {
  snapshot.drawImage(cameraFeed, 0, 0, 640, 480);
});
