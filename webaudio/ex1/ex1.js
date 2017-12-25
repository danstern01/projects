var playing = false;
var c = new (window.AudioContext || window.webkitAudioContext)();

// Oscillator variable, create outside of playSound function.
// Note, you cannot call oscillator.start() more than once.
// Instead you create new oscillator each time.
var o;

function playSound1() {
  if( playing == true) {
    o.stop();
    playing = false;
    document.getElementById("b1").value = "Play 1";
  }
  else {
    playing = true;
    document.getElementById("b1").value = "Stop Playing 1";
    o = c.createOscillator();
    o.type = 'sine';
    o.frequency.value = 2500;
    o.connect(c.destination);
    o.start();
  }
}
