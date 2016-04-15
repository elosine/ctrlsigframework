SerialPort.listDevices
~ino = ArduinoSMS("/dev/tty.usbmodem1a141", 9600);
~ino.action = {|msg|
	var msgsplit = split(msg, $:);
	var header = msgsplit[0].asSymbol;
	var val = msgsplit[1].asFloat;

	//Pot 0
	if( header == \p0, {
		s.sendMsg(\c_set, 0, val);
	} );
	//Button 0
	if( header == \b0, {
		if(val==0, {s.sendMsg(\n_set, 3000, \gate, 0)}, {s.sendMsg(\n_set, 3000, \gate, 1)});
	} );
	//Button 0 - toggle
	if( header == \bt0, {
		val.postln;
	} );

};

SynthDef(\a2sctest, {
	arg freq=300, gate=0;
	var env;
	env = EnvGen.ar(Env.asr(), gate);
	Out.ar(0, SinOsc.ar(freq)*env);
}).add;

s.sendMsg(\s_new, \a2sctest, 3000, 0, 1);
s.sendMsg(\n_set, \gate, 1);
s.sendMsg(\n_map, 3000, \freq, 0);
s.queryAllNodes







