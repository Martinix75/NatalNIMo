import picostdlib/[stdio, gpio, time]
#import strutils
import random
import initNat
import sequencer as natSeq

const natalNimoVer* = "0.3.1"

stdioInitAll()
#---------- inizializzazione dei pin ----------
const lWhite = 0.Gpio; lWhite.init(); lWhite.setDir(Out)
const lBlue = 1.Gpio; lBlue.init(); lBlue.setDir(Out)
const lGreen = 2.Gpio; lGreen.init(); lGreen.setDir(Out)
const lYellow = 3.Gpio; lYellow.init(); lYellow.setDir(Out)
const lRed = 4.Gpio; lRed.init(); lRed.setDir(Out)
const row1 = 5.Gpio; row1.init(); row1.setDir(Out)
const row2 = 6.Gpio; row2.init(); row2.setDir(Out)
const row3 = 7.Gpio; row3.init(); row3.setDir(Out)
const row4 = 8.Gpio; row4.init(); row4.setDir(Out)
const column1 = 9.Gpio; column1.init(); column1.setDir(Out)
const column2 = 10.Gpio; column2.init(); column2.setDir(Out)
const column3 = 11.Gpio; column3.init(); column3.setDir(Out)
const column4 = 12.Gpio; column4.init(); column4.setDir(Out)
const column5 = 13.Gpio; column5.init(); column5.setDir(Out)
#---------- fine inizializzazione pin ----------
#---------- prototipi funzioni -----------------
proc sequenceInit(natSeqInt: openArray[NatInt], repeat: int = 1, nome: string = "None") #string solo x test
proc decToBin(number: int): array[nLeds, uint8] {.inline.}
proc natEngine(natTupInt: NatInt)
proc ledSequencer(seqleds: array[nLeds, uint8], indexColu, indexRow: int) {.inline.}
proc scanMatrix(indexColu, indexRow: int) {.inline.}
proc setZero()
proc numberCyclesCalculate(ledPersistenceTime: int, milSeconds: int): int
#---------- fine prototipi ---------------------
#---------- inizio funzioni di gestione --------

proc sequenceInit(natSeqInt: openArray[NatInt], repeat: int = 1, nome: string = "None") = #proc per inizializzare il disegno ed ripetizioni seq.
  print("Nome Fx = " & nome)
  var repeatfx = repeat
  if repeatfx == -1:
     repeatfx = randomInt(1, 4)
     print("assegno numero ripetizioni = " & $repeatfx)
  let sizeSeq = len(natSeqInt) - 1 #calcola la lunghezza sequenza ( -1 )
  #print("elementi in seq, init--> " & $sizeSeq)
  for _ in countup(1, repeatfx): #numero ripetizioni sequenza inviata
    for indexSeq in countup(0, sizeSeq): #manda al motore uan alla volta le Natint contenute in sequenza
      natEngine(natSeqInt[indexSeq])
 
proc decToBin(number: int): array[nLeds, uint8] {.inline.} = #conversione del numero in bit (10 = 0,1,0,1,0)
  var 
    numberCopy: int = number #copia il numero per essere manipolato
    index: uint8 = 0 #indice incrementabile
  while numberCopy > 0: #gira finche numberCopy rimane > 0
    if numberCopy mod 2 != 0: #se il numero è divisibile per 2..
      result[index] = 1 #metti nell'array un 1
    else:
      result[index] = 0 #se non divisibile per 2, metti 0 nell'array
    numberCopy = numberCopy div 2 #fa uan divisione senza resto(troncato) per 2
    index.inc() #incrementa l'indice

proc natEngine(natTupInt: NatInt) = #motore principale per NatalNimo
  const ledPersistenceTime = 100 #tempo persistenza led in microsecondi
  let cyclesNumber = numberCyclesCalculate(ledPersistenceTime, natTupInt.milSeconds)
  for n in countup(0, cyclesNumber - 1): #cicla n volte per avre il tempo persistenza desiderato
    for indexColu in countup(0, nColumns - 1):#scansiona le colonne ciclo lento
      for indexRow in countup(0, nRows - 1): #scansiona le righe ciclo veloce
        ledSequencer(decToBin(natTupInt.data[indexColu][indexRow]), indexColu, indexRow)
        sleepMicroSeconds(ledPersistenceTime)
    #print("Numeri di cicli fatti: " & $n & '\n')
        
proc ledSequencer(seqleds: array[nLeds, uint8], indexColu, indexRow: int) {.inline.} = #inzial la sequanza accensioen dei led (in bit)
  setZero() #si spegne tutto (reset cosi sappiamo la condizione)
  #print("array led --> " & $seqleds & '\n')
  lWhite.put(seqleds[0].Value)
  lBlue.put(seqleds[1].Value)
  lGreen.put(seqleds[2].Value)
  lYellow.put(seqleds[3].Value)
  lRed.put(seqleds[4].Value)
  scanMatrix(indexColu, indexRow)
  
proc scanMatrix(indexColu, indexRow: int) {.inline.} = #funzione per accendere i trasistor della matrice
  #print("Ciclo --> " & $indexColu & $indexRow & '\n')
  case indexRow #accende il trasistor in base al numoro colonna passato dai cicli sopra
  of 0: row1.put(High)
  of 1: row2.put(High)
  of 2: row3.put(High)
  of 3: row4.put(High)
  else: setZero()
  case indexColu
  of 0: column1.put(High)
  of 1: column2.put(High)
  of 2: column3.put(High)
  of 3: column4.put(High)
  of 4: column5.put(High)
  else: setZero()
   
proc setZero() = #proc per portare tutto a zero (spento) vediamo se serve cosi o modicicata
  #[lWhite.put(Low); lBlue.put(Low); lGreen.put(Low); lYellow.put(Low); lRed.put(Low)
  row1.put(Low); row2.put(Low); row3.put(Low); row4.put(Low)
  column1.put(Low); column2.put(Low); column3.put(Low); column4.put(Low); column5.put(Low)]#
  putAll(0x0000) #porta tutto a zero con la nuva funzione wrappata
  
proc numberCyclesCalculate(ledPersistenceTime: int, milSeconds: int): int = #calcola quanti cicli fare per avre i sec voluti
  var cazzzone = milSeconds
  if milSeconds < 0:
    cazzzone = randomInt(0, abs(milSeconds))
    print("secondi casuali--> " & $cazzzone)
  let timeDivider = (ledPersistenceTime * (nColumns * nRows) / 1000)
  result = int(float(cazzzone) / timeDivider)
#---------- fine funzioni di gestione --------
sleep(1500)
print("NatalNimo Version: " & natalNimoVer & '\n')
print("Sequencer Version: " & natSeq.sequencerVer & '\n')
print("Inizio.." & '\n')
var randFx: int
while true: #inizia il ciclo infinito...
  randFx = randomInt(1, 5)
  case randFx
  of 1: sequenceInit(natSeq.fireUp, -1, "FireUp Nuova")
  of 2: sequenceInit(natSeq.superCar, -1, "SuperCar")
  of 3: sequenceInit(natSeq.allOn, -1, "AllOn")
  of 4: sequenceInit(natSeq.casualeFx(), -1, "Casuale") #non calcolabile in compilazione (numeri casuali)
  of 5:sequenceInit(natSeq.ruota, -1, "Ruota")
  of 6:sequenceInit(natSeq.alternate, -1, "Alternata")
  else: sequenceInit(natSeq.casualeFx(), 1, "Casuale Emergengy")
  #[case randFx
  of 1: sequenceInit(natSeq.casualeFx(), 1, "Casuale") #non calcolabile in compilazione (numeri casuali)
  of 2: sequenceInit(natSeq.multi, -1, "Multi") #sequenzafissa calcolabile in compilazione!
  of 3: sequenceInit(natSeq.allOn, 1, "AllOn")
  of 4: sequenceInit(natSeq.test, 1, "Test")
  of 5: sequenceInit(natSeq.fireUp,  1, "FireUp") #da studiare come mandare parametri..
  else: sequenceInit(natSeq.casualeFx(), 1, "Casuale Emergengy")
  ]#
  
  


  

