SerialPort.listDevices
(
~ino = ArduinoSMS("/dev/tty.usbmodem1a141", 9600);
//CONTINUOUS CONTROLLERS
~cch = [\p0, \p1, \p2, \p3, \p4, \p5, \p6];//continuous controller headers
~ccm = [ //continuous controller mappings
	[0, 1023, 300.0, 1200.0],
	[0, 1023, 0.0, 1.0],
	[0, 1023, 0.0, 1.0],
	[0, 1023, 0.0, 1.0],
	[0, 1023, 0.0, 1.0],
	[0, 1023, 0.0, 1.0],
	[0, 1023, 0.0, 1.0]
];
//DISCRETE CONTROLLER
~dch = [\b0, \b1, \b2, \b3, \b4, \b5, \b6]; //discrete controller headers
~dcfd = ();
~dch.do{|it ix| ~dcfd.put(it, { |val| val.postln } ) };  //setting dict and putting holder functions

//practice add function to buttons
~dcfd[ ~dch[2] ] = 77;

~dcfd[ \b2 ] = {|val| s.sendMsg(\n_set, 3000, \gate, val) };//use this template to add functions to correspond to your buttons or discrete controllers
)
(
~ino.action = { |msg|

	var msgsplit = split(msg, $:);
	var header = msgsplit[0].asSymbol;
	var val = msgsplit[1].asFloat;

	//All Continuous Controllers
	~cch.do{|it ix| //iterate through the continous controller headers
		if( header == it, { // sort for a particular header
			s.sendMsg( \c_set, ix, val.linlin( ~ccm[ix][0], ~ccm[ix][1], ~ccm[ix][2], ~ccm[ix][3] ) ); //setting the appropriate control bus with a value and map it
		})
	};

	//All Momentary Discrete Controllers
	~dch.do{|it ix|
		if( header == it,{
			~dcfd[it].value(val);
		});
	};

	//Button 0 - toggle
	if( header == \bt0, {
		//val.postln;
	} );

};
)

SynthDef(\a2sctest, {
	arg freq=300, gate=0;
	var env;
	env = EnvGen.ar(Env.asr(), gate);
	Out.ar(0, SinOsc.ar(freq)*env);
}).add;

s.sendMsg(\s_new, \a2sctest, 3000, 0, 1);
s.sendMsg(\n_set, \gate, 1);
s.sendMsg(\n_map, 3000, \freq, 0);
s.queryAllNodes;

//Change mappings on the fly
~ccm[0] = [0, 1023, 1.0, 22.0];
//To get control bus values
OSCFunc({|msg| msg.postln;}, \c_set);
s.sendMsg(\c_get, 0);







