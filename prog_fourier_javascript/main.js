
let canvas1 = document.getElementById("canvas1");
let ctx1 = canvas1.getContext("2d");
// flip le repère
ctx1.translate(0 , canvas1.height/2);
ctx1.scale(1 , -1);

function drawText(ctx, text, x, y){
	ctx.beginPath();
	ctx.fillStyle = "black";
	ctx.font = '15px serif';
	ctx.scale(1, -1);
	ctx.fillText( text, x, -y ); 
	ctx.scale(1, -1);
}
function drawSignal(ctx, input, scaleX, scaleY, incrX, incrY, color){
	ctx.strokeStyle = color;
	ctx.beginPath();
	ctx.moveTo(incrX, input[0]*scaleY + incrY);
	for (let i = 1; i < input.length; i++) ctx.lineTo(i*scaleX + incrX, input[i]*scaleY + incrY);
	ctx.stroke();
}

function integrateSignal(input, sampleSize){
	let total = 0;
	for (let i = 0; i < input.length; i++){
		total += input[i] * sampleSize;
		input[i] = total;
	}
}
function squareSignal(input){
	
}

// gen. sinusoide ---------------------------------------------------------------------------------------
const input =[];
// sinusoide
let a = 50;
let f = 20; // Hz
let w = 2*Math.PI*f;
let incr = 0;
let phi = 0;

let t0 = 0;

let duration = 1; // s
let numSamples = 100 * f * duration; // nyquist-shannon theorem says 2 is enough
let sampleSize = duration / numSamples;

let signal;
for (let i = 0; i < numSamples; i++){
	signal = a * Math.sin( w*(t0 + i*sampleSize) + phi ) + a/3 * Math.cos( 5*w*(t0 + i*sampleSize) + 2 ) + incr;
	
	// racine
	signal = Math.sqrt(Math.abs(signal));
	
	input.push( signal );
}
// ----------------------------------------------------------------------------------------------------------

//integrateSignal(input, sampleSize);
//integrateSignal(input, sampleSize);

drawSignal(ctx1, input, canvas1.width / duration * sampleSize, 10, 0, 100, "red");

// info repère
/*
ctx1.beginPath();
ctx1.strokeStyle = "#000000";
ctx1.lineWidth = 2;
ctx1.moveTo(0, 0); ctx1.lineTo(canvas1.width, 0);
ctx1.stroke();
ctx1.beginPath();
ctx1.fillStyle = "black";
ctx1.font = '24px serif';
ctx1.scale(1, -1); ctx1.fillText( duration + "s", canvas1.width - 40, +30 ); ctx1.scale(1, -1);
*/

// analyse spectrale 
let out = dft( input );
out = out.slice(0, Math.ceil(out.length/2));
out.forEach((val, i, arr) => arr[i] = val.getRadius());
out[0] = 0; // don't display amplitude of f = 0Hz

let offX = 20; let offY = -200; let xScale = canvas1.width / out.length;
drawSignal(ctx1, out, xScale, 300, offX, offY, "green");
for (let i = 1; i < out.length/2; i++) if (out[i] > 0.01) console.log("freq. : " + i * 1 / duration + " ; ampl : " + out[i] );

// info analyse spectrale
for (let i = 1; i < out.length; i+= Math.round(out.length/10)){
	drawText(ctx1, i + "Hz", offX + i*xScale, offY - 30);
}

