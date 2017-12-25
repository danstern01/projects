var c = new (window.AudioContext || window.webkitAudioContext)();

var playing1 = false;
var playing2 = false;

// Oscillator variable, create outside of playSound function.
// Note, you cannot call oscillator.start() more than once.
// Instead you create new oscillator each time.
var o1;
var o2;


function playSound1() {
  if( playing1 == true) {
    o1.stop();
    playing1 = false;
    document.getElementById("b1").value = "Play 1";
  }
  else {
    playing1 = true;
    document.getElementById("b1").value = "Stop Playing 1";
    o1 = c.createOscillator();
    o1.type = 'sine';
    o1.frequency.value = 2500;
    o1.connect(c.destination);
    o1.start();
  }
}

function playSound2() {
  if( playing2 == true) {
    o2.stop();
    playing2 = false;
    document.getElementById("b2").value = "Play 2";
  }
  else {
    playing2 = true;
    document.getElementById("b2").value = "Stop Playing 2";
    o2 = c.createOscillator();
    o2.type = 'saw';
    o2.frequency.value = 4000;
    o2.connect(c.destination);
    o2.start();
  }
}
