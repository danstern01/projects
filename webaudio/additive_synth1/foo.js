var c = new (window.AudioContext || window.webkitAudioContext)();

class SimpleAdditiveSynthesis {
  constructor() {
    this.o = null;
    this.gain = 0;
    this.playing = false;
  }
  init(freqs, gain_value) {
    var osc = [];
    this.gain = c.createGain();
    for (let i in freqs) {
      osc[i] = c.createOscillator();
      osc[i].frequency.value = freqs[i];
      osc[i].connect(this.gain);
    }
    this.gain.connect(c.destination);
    this.gain.gain.value = gain_value;
    this.o = osc;
  }
  start() {
    for (let i in this.o) {
       this.o[i].start();
    }
    this.playing = true;
  }
  stop() {
    for (let i in this.o) {
       this.o[i].stop();
    }
    this.playing = false;
  }
}

class SimpleHarmonicSeries {
  constructor() {
    this.o = null;
    this.gain = 0;
    this.playing = false;
  }

  init(fundamental, num_harmonics, gain_value) {
    var osc = [];
    var freqs = [];
    var gains = [];
    this.gain = c.createGain();
    for (let i=0; i < num_harmonics; ++i) {
      console.log("Harmonic " + i + ":");
      osc[i] = c.createOscillator();
      let freq = fundamental * (i+1);
      console.log("   assigning frequency: " + freq);
      osc[i].frequency.value = freq;
  
      gains[i] = c.createGain();
      let gainval = 0.1 * (i + 1);
      console.log("   assigning gain: " + gainval);
      gains[i].gain.value = gainval;
  
      osc[i].connect(gains[i]);
      gains[i].connect(this.gain);
    }
    this.gain.connect(c.destination);
    this.gain.gain.value = gain_value;
    this.o = osc;
  }
  start() {
    for (let i in this.o) {
       this.o[i].start();
    }
    this.playing = true;
  }
  stop() {
    for (let i in this.o) {
       this.o[i].stop();
    }
    this.playing = false;
  }
}

var a1 = new SimpleAdditiveSynthesis();
var h1 = new SimpleHarmonicSeries();

function playSound1() {
  if( a1.playing == true) {
    a1.stop();
    document.getElementById("b1").value = "Play 1";
  }
  else {
    a1.init([440, 550, 660], 0.3);
    a1.start()
    document.getElementById("b1").value = "Stop Playing 1";
  }
}

function playSound2() {
  if( h1.playing == true) {
    h1.stop();
    document.getElementById("b2").value = "Play 2";
  }
  else {
    h1.init(440, 5, 0.3);
    h1.start();
    document.getElementById("b2").value = "Stop Playing 2";
  }
}

function playSounds1and2() {
  playSound1();
  playSound2();
}
