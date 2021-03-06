// SimpleNumber.round(x): rounds to a multiple of x
// this forces output as harmonics of x

SynthDef.new(\blip,
	{
	arg out, fund=440, decay=0.2, dens = 20, vol=0.25;

	var freq, trig, sig;
	freq = LFNoise0.kr(2).exprange(fund, fund*4).round(fund);
	sig = SinOsc.ar(freq) * vol;
	trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
	}
).add;


SynthDef.new(\reverb,
	{
	arg in, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
	}
).add;


~reverbBus  = Bus.audio(s, 1);
~reverbBus2 = Bus.audio(s, 2);


x=Synth.new(\reverb, [\in, ~reverbBus2]);
8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverbBus2,
			\fund, exprand(60,300).round(30),
			//\fund, rrand(60,300).round(30),
			//\fund, 300,
			\decay, 0.5,
			\dens, 20,
			\vol, 0.5
		],
		~sourceGrp
	);
}




//x=Synth.new(\reverb, [\in, 6]);
//y=Synth.new(\blip, [\out, 6]);


//y=Synth.new(\blip, [\out, ~reverbBus2]);

