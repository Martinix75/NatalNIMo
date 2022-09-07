import random
import initNat

const
  sequencerVer* = "0.4.0"
  
# ---------- Funzioni Private di Utilità -----------
proc initNatSeq(noFrames = 1): seq[Natint] = #inizializza le sequenze a zero se occorre
  var tempFx: Natint
  for _ in countup(0, noFrames - 1):
    tempFx.milSeconds = 0
    for x in  countup(0, nColumns - 1):
      for y in countup(0, nRows - 1):
        tempFx.data[x][y] = 0
    result.add(tempFx)

# procedura per invertire uan sequenza gia calcolata prima
proc invertNatSeq(natSeq: seq[Natint]): seq[Natint] = #inverte sequenze di farme gia calcolate
  let lenSeq = len(natSeq)
  for c in countdown(lenSeq-1, 0):
    result.add(natSeq[c])

proc upFx(arrayFx: openArray[array[0..nRows-1, int]]; msec = 1000; testStr: string): seq[NatInt] =
  echo("Calcolo ", testStr, " in compilazione..")
  let lenArrayFx = len(arrayFx) #calcola quanti elementi ci sono nell'array
  var sequenceFx = initNatSeq(lenArrayFx)# inizializza i frame necessari a zero
  var indexArrayFx = 0 #inizializza a 0 l'indice dell'array passato
  for indexFrame in countup(0, lenArrayFx-1): #questo indice percorre tutti i frame...
    for indexColumn in countup(0, nColumns-1): #questo indice percorre tutte le colonne del frame..
      sequenceFx[indexFrame].data[indexColumn] = arrayFx[indexArrayFx] #mette l'array passato su tutte le colonne 
      sequenceFx[indexFrame].milSeconds = msec #imposta i secondi di permanenza scelto
    indexArrayFx.inc
    if indexArrayFx >= len(arrayFx):
      indexArrayFx = 0
  result = sequenceFx

proc rotationFx(arrayFx: openArray[array[0..nRows-1, int]]; msec = 1000; testStr: string): seq[NatInt] =
  echo("Calcolo RotationFx ", testStr, " in compilazione..")
  let lenArrayFx = len(arrayFx) #calcola quanti elementi ci sono nell'array
  var sequenceFx = initNatSeq(lenArrayFx)# inizializza i frame necessari a zero
  var temporany: array[0..nRows-1, int] #variabile per la conservazione momentane dall'ulòtima valore (fa swap)
  for cazzo in countup(0, nColumns-1):
    sequenceFx[0].data[cazzo] = arrayFx[cazzo]#crea il primo frame come indicato dai dati ricevuti
    sequenceFx[0].milseconds = msec
  for vacca in countup(1, lenArrayFx-1):
    for lupo in countup(0, nColumns-2):
      temporany = sequenceFx[vacca-1].data[4] #memorizza temporaneamnet l'ultimo valore del array (è un array a sau volta)
      sequenceFx[vacca].milseconds = msec
      sequenceFx[vacca].data[lupo+1] = sequenceFx[vacca-1].data[lupo]# sposta gli array di uan posizione verso dx
      sequenceFx[vacca].data[0] = temporany #mette in prima posizione il dato memorizzato (da ultimo-->primo)
  result = sequenceFx
  
# ---------- Funzioni Statiche indirette -----------
proc testFx(): seq[NatInt] = #possibile calcolara in compilazione si passano come const
  echo "testFx calcolata.."
  let singleSeq = (data: [[1,0,0,0], [1,0,0,0], [1,12,13,14], [1,17,18,19], [1,18,19,31]], milSeconds: -1) 
  result.add(singleSeq)

#accende tutto l'albero (tutti led accessi contemporaneamente)
proc allOnFx(): seq[NatInt] =
  echo "allOnFx calcolata.."
  let singleSeq = (data: [[31,31,31,31], [31,31,31,31], [31,31,31,31], [31,31,31,31], [31,31,31,31]], milSeconds: -1) 
  result.add(singleSeq)


  
# ---------- Funzioni Statiche indirette fine -----------
# ---------- Funzioni Dinamiche dirette -----------------

# questa procedura accende i led a caso.
proc casualeFx*(): seq[NatInt] = #non possibile da calcolare in compilazione si passano dirette
  randomize()
  var natIntSeqTemp: NatInt 
  natIntSeqTemp.milSeconds = randomInt(20, 5000)
  for x in countup(0, nColumns - 1):
    for y in countup(0, nRows - 1):
      natIntSeqTemp.data[x][y] = randomInt(0, 31)
  result.add(natIntSeqTemp)
  
# ---------- Funzioni Dinamiche dirette fine -------------

#da qui iniziano le sequenze base fatte a mano poi espanse automaticamente:
const #le sequenze costani in verticale qui...
  fireUpData = [[0,0,0,16],[0,0,0,24], [0,0,0,28],[0,0,0,30], [0,0,0,31],[0,0,16,31],[0,0,24,31],[0,0,28,31],[0,0,30,31],[0,0,31,31],
              [0,16,31,31],[0,24,31,31], [0,28,31,31],[0,30,31,31],[0,31,31,31],[16,31,31,31],[24,31,31,31],[28,31,31,31],[30,31,31,31],
              [31,31,31,31]] 
  superCarData =  [[0,0,0,16],[0,0,0,24],[0,0,0,28],[0,0,0,14],[0,0,0,7],[0,0,16,3],[0,0,24,1],[0,0,28,0],[0,0,14,0],[0,0,7,0],[0,16,3,0],[0,24,1,0],
                  [0,28,0,0],[0,14,0,0],[0,7,0,0],[16,3,0,0],[24,1,0,0],[28,0,0,0],[14,0,0,0],[7,0,0,0],[3,0,0,0],[1,0,0,0]]
# ------------------------------------
#da qui iniziano le sequenze di rotazione 5 elementi max!!
const
  rotation = [[31,31,31,31],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
  alterno =  [[21,21,21,21],[10,10,10,10],[21,21,21,21],[10,10,10,10],[21,21,21,21]]
# richiamo delel funzioni...
const
  fireUp* = upFx(fireUpData, 100, "fireUP_Data")
  superCar* = upFx(superCarData, 50, "superCar_Data")
  ruota* = rotationFx(rotation, 500, "Girotondo")
  alternate* = rotationFx(alterno, 500, "Alternata")
  allOn* = allOnFx()

