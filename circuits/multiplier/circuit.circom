pragma circom 2.0.0;

/*This circuit template checks that c is the multiplication of a and b.*/  

template Multiplier2 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;
   signal x;  
   signal y;  
   signal output c;

   //component
   component andGate = AND();
   component notGate = NOT();
   component orGate = OR();

   // Logic From AND to singals
   andGate.a <== a;
   andGate.b <== b;
   x <== andGate.out;

   // Logic From Signals to Not Gate 
   notGate.in <== b;
   y <== notGate.out;

   //Logic From Not gate to Output C
   orGate.a <== x;
   orGate.b <== y;
   c <== orGate.out;

}

template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;
}

template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

component main = Multiplier2();