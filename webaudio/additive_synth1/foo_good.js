var c = new (window.AudioContext || window.webkitAudioContext)();

// Note, you cannot call oscillator.start() more than once.
// Instead you create new oscillator each time.
var o1;
var gain1;
var playing1 = false;
var o2;
var gain2;
var playing2 = false;

function startAdditiveSynthesis(oscNodes) {
  for (i in oscNodes) {
     oscNodes[i].start();
  }
}
function stopAdditiveSynthesis(oscNodes) {
  for (i in oscNodes)
     oscNodes[i].stop();
}

function simpleAdditiveSynthesis(freqs, gain_value) {
  var osc = [];
  gain2 = c.createGain();
  for (i in freqs) {
    osc[i] = c.createOscillator();
    osc[i].frequency.value = freqs[i];
    osc[i].connect(gain2);
  }
  gain2.connect(c.destination);
  gain2.gain.value = gain_value;
  return osc;
}

function simpleHarmonicSeries(fundamental, num_harmonics, gain_value) {
  var osc = [];
  var freqs = [];
  var gains = [];
  gain2 = c.createGain();
  for (i=0; i < num_harmonics; ++i) {
    console.log("Harmonic " + i + ":");
    osc[i] = c.createOscillator();
    freq = fundamental * (i+1);
    console.log("   assigning frequency: " + freq);
    osc[i].frequency.value = freq;

    gains[i] = c.createGain();
    var gainval = 0.1 * (i + 1);
    console.log("   assigning gain: " + gainval);
    gains[i].gain.value = gainval;

    osc[i].connect(gains[i]);
    gains[i].connect(gain2);
  }
  gain2.connect(c.destination);
  gain2.gain.value = gain_value;
  return osc;
}

function playSound1() {
  if( playing1 == true) {
    stopAdditiveSynthesis(o1);
    playing1 = false;
    document.getElementById("b1").value = "Play 1";
  }
  else {
    o1 = simpleAdditiveSynthesis([440, 550, 660], 0.3);
    startAdditiveSynthesis(o1);
    playing1 = true;
    document.getElementById("b1").value = "Stop Playing 1";
  }
}

function playSound2() {
  if( playing2 == true) {
    stopAdditiveSynthesis(o2);
    playing2 = false;
    document.getElementById("b2").value = "Play 2";
  }
  else {
    o2 = simpleHarmonicSeries(440, 5, 0.3);
    startAdditiveSynthesis(o2);
    playing2 = true;
    document.getElementById("b2").value = "Stop Playing 2";
  }
}
