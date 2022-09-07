const 
  nRows*: int = 4 #numero di righe (elementi x piano) pressenti). 5
  nColumns*: int = 5 #numero colonne (numero di piani presenti).4
  nLeds*:int = 5 #numero dei led per cella 5

type
  NatInt* = tuple[data: array[0..nColumns - 1, array[0..nRows - 1, int]], milSeconds: int] # (array[0..3, array[0..4, int]], int) ->emergengy
