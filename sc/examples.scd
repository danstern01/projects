// from cello to harp-ish sound

(
// ^^^^^^^^ double click above this line ^^^^^^^^
play({
// Three patches in one...
n = 5;    // number of strings
b = [    // array of possible impulse excitation behaviours
        //{ Impulse.ar(2 + 0.2.rand, 0.3) }, // slow phasing
		{ Impulse.ar(1, 0.3) }, // deterministic slow phasing
        { Dust.ar(10, 0.1) },    // "wind chimes"
	 { Blip.ar(1, 150, 0.001) },    // "wind chimes"
       { Impulse.ar(SinOsc.kr(0.05+0.1.rand, 2pi.rand, 5, 5.2), 0.3, 0.2) } // races
    ].choose;    // choose one at random to use for all voices
Mix.new(
    Array.fill(n, {    // n strings tuned randomly to MIDI keys 60-90
        var delayTime;

        // calculate delay based on a random note
        //delayTime = 1 / (50 + 30.rand).midicps;
			delayTime = 1/50.midicps;
        Pan2.ar(
            LeakDC.ar(    // removes DC buildup
                CombC.ar(    // used as a string resonator
                    Decay.ar(    // decaying envelope for noise
                        b.value,// instantiate an exciter
                        0.50,    // decay time of excitation
                        PinkNoise.ar(0.2)// multiply noise by envelope
					),
					delayTime,     // max comb delay time
                    delayTime,    // actual comb delay time
					15 // comb decay time of string
				)
			)
			,
            1.0.rand2 // random pan position
        )
    }))
})
)

// sine
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;



// multichannel
// when choose (randomly) selects a single number
// from the array, you get 1 sine. When it selects an
// array of two numbers, you get a pair of sines, i.e.,
// stereo.
//
(
{ var freq;
    freq = [[660, 880], [440, 660], 1320, 880].choose;
    SinOsc.ar(freq, 0, 0.2);
}.play;
)

// deconstructing the above determinstically
(
{ var freq;
	freq = [[660, 880]];
    SinOsc.ar(freq, 0, 0.2);
}.play;
)

(
{ var freq;
	freq = [[440, 660]];
    SinOsc.ar(freq, 0, 0.2);
}.play;
)

(
{ var freq;
	freq = [1320];
    SinOsc.ar(freq, 0, 0.2);
}.play;
)

(
{ var freq;
	freq = [880];
    SinOsc.ar(freq, 0, 0.2);
}.play;
)



// panning noise
{ Pan2.ar(PinkNoise.ar(0.2), SinOsc.kr(0.5)) }.play;

SynthDef("help-Pan2", { Out.ar(0, Pan2.ar(PinkNoise.ar(0.4), FSinOsc.kr(2), 0.3)) }).play;

// two channels
{ [ Blip.ar(800,4,0.1), WhiteNoise.ar(0.1) ] }.play;


{ RLPF.ar(Saw.ar([100,250],0.05), XLine.kr([8000,500],[400,7000],5), 0.05) }.play;

{ Saw.ar([100,250]) * [0.5,0.8] }.play;
{ Saw.ar(LFNoise1.kr(1).range(0,100) + [100,250])}.play;

//flop
(
SynthDef("help_multichannel", { |out=0, freq=440, mod=0.1, modrange=20|
    Out.ar(out,
        SinOsc.ar(
            LFPar.kr(mod, 0, modrange) + freq
        ) * EnvGate(0.1)
    )
}).send(s);
)

(
var freq, mod, modrange;

freq = Array.exprand(8, 400, 5000);
mod = Array.exprand(8, 0.1, 2);
modrange = Array.rand(8, 0.1, 40);

fork {
    [\freq, freq, \mod, mod, \modrange, modrange].flop.do { |args|
        args.postln;
        Synth("help_multichannel", args);
        0.3.wait;
    }
};
)


(
SynthDef("blip", { |freq| Out.ar(0, Line.ar(0.1, 0, 0.05, 1, 0, 2)
    * Pulse.ar(freq * [1, 1.02])) }).send(s);

a = { |dur=1, x=1, n=10, freq=400|
    fork { n.do {
            if(x.coin) { Synth("blip", [\freq, freq]) };
            (dur / n).wait;
    } }
}.flop;
)

a.value(5, [0.3, 0.3, 0.2], [12, 32, 64], [1000, 710, 700]);

// mixdown
{ Mix.new(  Pulse.ar([400, 501, 600], [0.5, 0.1], 0.1) ) }.play

// japanese sounding
(
{
    var n;
    n = 8; // number of 'voices'
    Mix.new( // mix all stereo pairs down.
        Pan2.ar( // pan the voice to a stereo position
            CombL.ar( // a comb filter used as a string resonator
                Dust.ar( // random impulses as an excitation function
                    // an array to cause expansion of Dust to n channels
                    // 1 means one impulse per second on average
                    Array.fill(n, 1),
                    0.3 // amplitude
                ),
                0.01, // max delay time in seconds
                // array of different random lengths for each 'string'
                Array.fill(n, {0.004.rand+0.0003}),
                4 // decay time in seconds
            ),
            Array.fill(n,{1.0.rand2}) // give each voice a different pan position
        )
    )
}.play;
)

// addition

{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.play;


// one channel
{ Mix.new([SinOsc.ar(440, 0, 0.2), Saw.ar(660, 0.2)]).postln }.play;

// combine two stereo arrays
(
{
    var a, b;
    a = [SinOsc.ar(440, 0, 0.2), Saw.ar(662, 0.2)];
    b = [SinOsc.ar(442, 0, 0.2), Saw.ar(660, 0.2)];
    Mix([a, b]).postln;
}.play;
)

// Look at the post window for frequencies and indices
(
    var n = 8;
    {
        Mix.fill(n, { arg index;
            var freq;
            index.postln;
            freq = 440 + index;
            freq.postln;
            SinOsc.ar(freq , 0, 1 / n)
        })
    }.play;
)








