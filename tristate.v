//------------------------------------------------------------------------
// Tristate
//------------------------------------------------------------------------

module tristate
(
  in,
  enable,
  out
);

  input in;
  input enable;
  output out;

  assign out = enable?in:'bz;
endmodule