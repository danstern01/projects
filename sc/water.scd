
// recorder sound from pair of sinewaves
// A SynthDef is created that takes a freq arg and computes its 5th,
// then plays the fundamental and 5th.
// A Synth is created from this and played.




(
SynthDef("recorder", {
	arg freq;
	var out;
	out = SinOsc.ar(freq, 0, 0.2);
	out = Pan2.ar(out, 0);
	Out.ar(0, out);
}).add;

SynthDef("recorder_pair", {
	arg freq;
	var out1, out2, octave, note, freq2;
	octave = freq * 2;
	note = (octave - freq) / 8;
	freq2 = freq + (note * 4);
	out1 = SinOsc.ar(freq, 0, 0.2);
	out2 = SinOsc.ar(freq2, 0, 0.2);
	//out1 = Pan2.ar(out1, 0);
	//out2 = Pan2.ar(out2, 0);
	Out.ar(0, out1);
	Out.ar(1, out2);
}).add;
)



a = Synth("recorder_pair", [ "freq", 440] );
a.free;

a = Synth("recorder_pair", [ "freq", 330] );
a.free;

b=Synth("recorder", [ "freq", 880] );







