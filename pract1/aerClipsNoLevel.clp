;; =============================================================
;; Documentación
;; =============================================================

;; -------------------------------------------------------------
;; Descripción y especificaciones del problema
;; -------------------------------------------------------------
;; Se tienen que repartir una serie de maletas de unos nodos a otros mediante unos vagones y una máquina
;; 1.- Las maletas tienen un peso (peso) y un identificador (mx)
;; 2.- Los vagones tienen un rango de pesos que pueden llevar (pesoMinimo, pesoMaximo) para las maletas y un identificador (vx). Un vagón puede llevar tantas maletas como se desee
;; 3.- Un vagón no puede contener maletas si no está enganchao a una máquina
;; 4.- La maquina tiene un identificador (maquina) y recorre los nodos. La maquina sólo puede cargar un vagón.
;; 5.- Hay caminos entre los nodos que sólo la máquina puede recorrer


;; -------------------------------------------------------------
;; Acciones Posibles y Restricciones
;; -------------------------------------------------------------
;; -> Dejar maleta
;;    - Si están en un vagón
;;    - Destino de la maleta tiene que ser la posición actual de la máquina
;;    - Si se deja en el destino, la cantidad de maletas del vagón que la llevaba disminuye
;;    - Una vez depositada en el destino ya no se debe mover
;;    - La máquina debe estar ocupada por el vagón del que se quiere dejar la maleta
;;
;; -> Recoger maleta
;;    - Siempre que no esté en un vagón
;;    - Se debe recoger de un nodo
;;    - Debe recogerla un vagón que esté en la máquina
;;    - Debe caber en el vagón que esta enganchado a la máquina
;;    - Si se recoger, se debe aumentar la cantidad de maletas del vagón
;;    - Una vez recogida se debe cambiar la posción de la maleta de un nodo al identificador del vagón que la ha recogido
;;    - No se debe recoger una maleta que está en su destino
;;
;; -> Enganchar vagón en máquina
;;    - Siempre que la máquina esté libre
;;    - El vagón debe estar en un nodo
;;    - El vagón debe estar vacío
;;    - Si se engancha, se debe cambiar la posición del vagón de un nodo a maquina
;;    - Si se engancha, la máquina cambia de estado libre a ocupada
;;
;; -> Desenganchar vagón de máquina
;;    - Siempre que el vagón esté en la máquina
;;    - Siempre que la máquina esté libre
;;    - El vagón debe estar vacío
;;    - Si se desengancha, la máquina pasa de estado ocupada a libre
;;    - Si se desengancha, la posición del vagón pasa de ser maquina a un nodo
;;
;; -> Mover máquina
;;    - Siempre que sea de un nodo a otro
;;    - Si se mueve, se debe cambiar la posición de la máquina de el nodo inicial al final
;;
;; -> Acabar programa
;;    - Cuando todas las maletas estén en el destino, es decir, cuando no haya más maletas que mover


;; -------------------------------------------------------------
;; Estados Estáticos
;; -------------------------------------------------------------
;; -> Maleta
;; (maleta my peso destino) / y >= 0 and destino = nodo
;;
;; -> Vagon
;; (vagon vx pesoMinimo pesoMaximo) / x >= 0
;;
;; -> Camino
;; (camino posicionInicial posicionFinal) / posicionInicial = nodo and posicionFinal = nodo


;; -------------------------------------------------------------
;; Estado Dinámico
;; -------------------------------------------------------------
;; -> Estado aerolínia
;; (state maquina posicionMaquina estadoMaquina iniVagon [dV] finVagon iniMaletas [dM] finMaletas)
;; posicionMaquina  -->   nodo
;; estadoMaquina    -->   ocupada | libre
;; dV               -->   vx posicionVagon cantidadMaletasVagon / x >= 0 and posicionVagon = nodo | maquina
;; dM               -->   my posicionMaleta / y >= 0 and posicionMaleta = nodo | vx


;; -------------------------------------------------------------
;; Definición de las reglas
;; -------------------------------------------------------------
;; moverMaquina -> Regla que se encarga de mover la máquinade un nodo a otro mediante un camino
;; dejarMaleta -> Regla que se encarga de dejar la maleta en el destino
;; recogerMaleta -> Regla que se encarga de recoger la maleta de un nodo
;; engancharVagonMaquina -> Regla que se encarga de enganchar el vagón en una máquina
;; desengancharVagonMaquina -> Regla que se encarga de desenganchar el vagón de la maquina
;; acabaPrograma -> Regla que se encarga de acabar el programa


;; =============================================================
;; Implementación
;; =============================================================

;; -------------------------------------------------------------
;; Definición de los hechos
;; -------------------------------------------------------------
;; -> Hechos estáticos
;; - Maletas
(deffacts maletas
 (maleta m1 12 p3)
 (maleta m2 18 p5)
 (maleta m3 20 re)
 (maleta m4 14 re)
)

;; - Vagones
(deffacts vagon
  (vagon t1 0 15)
  (vagon t2 16 23)
)

;; - Caminos entre nodos
(deffacts caminos
  (camino p2 fac)
  (camino p2 p4)
  (camino p4 p2)
  (camino p4 p3)
  (camino p3 p1)
  (camino p3 p4)
  (camino p1 fac)
  (camino p1 p5)
  (camino p1 p3)
  (camino fac p2)
  (camino fac p1)
  (camino p5 p1)
  (camino p5 re)
  (camino p5 p7)
  (camino re p5)
  (camino re p6)
  (camino p7 p5)
  (camino p7 p8)
  (camino p8 p7)
  (camino p8 p6)
  (camino p6 p8)
  (camino p6 re)
)

;; -> Hecho dinámico
(deffacts terminal
  (state maquina p6 ocupada
    iniVagon
      t1 maquina 0
      t2 p2 0
    finVagon
    iniMaletas
      m1 fac
      m2 fac
      m3 p1
      m4 p6
    finMaletas
  )
)

;; -------------------------------------------------------------
;; Implementación de las reglas
;; -------------------------------------------------------------

;; moverMaquina -> Regla que se encarga de mover la máquinade un nodo a otro mediante un camino
;; .............................................................
;; posicionMaquina == posicionNodoInicial
;; =>
;; posicionMaquina = posicionNodoFinal
(defrule moverMaquina
  (state maquina ?posicionNodoInicial $?resto)
  (camino ?posicionNodoInicial ?posicionNodoFinal)
  =>
  (assert (state maquina ?posicionNodoFinal $?resto))
)

;; dejarMaleta -> Regla que se encarga de dejar la maleta en el destino
;; .............................................................
;; posicionMaquina == destinoMaletaY
;; posicionMaletaY == vagonX
;; posicionVagonX == maquina
;; estadoMaquina == ocupada
;; =>
;; cantidadVagonX = pesoMaletaY
;; ... iniMaletas $?iniM $?finM finMaletas (Se quita la maleta del hecho dinámico, para que no se mueva más)
(defrule dejarMaleta
  (declare (salience 60))
  (state maquina ?destinoM ocupada
    iniVagon
      $?iniV ;; lista con vagones
        ?vx maquina ?cantidadV
      $?finV ;; lista con vagones
    finVagon
    iniMaletas
      $?iniM ;; lista con maletas
        ?mx ?vx
      $?finM ;; lista con maletas
    finMaletas
  )
  (maleta ?mx ?pesoM ?destinoM)
  =>
  (assert (state maquina ?destinoM ocupada
    iniVagon
      $?iniV ;; lista con vagones
        ?vx maquina (- ?cantidadV 1)
      $?finV ;; lista con vagones
    finVagon
    iniMaletas
      $?iniM ;; lista con maletas
      $?finM ;; lista con maletas
    finMaletas
  ))
)

;; recogerMaleta -> Regla que se encarga de recoger la maleta de un nodo
;; .............................................................
;; posicionMaquina == posicionMaleta
;; posicionVagon == maquina
;; pesoMinimo <= pesoMaleta
;; pesoMaximo >= pesoMaleta
;; estadoMaquina == ocupada
;; =>
;; posicionMaleta = vx
;; cantidadV += 1
(defrule recogerMaleta
  (declare (salience 40))
  (state maquina ?posicionM ocupada
    iniVagon
      $?iniV ;; lista con vagones
        ?vx maquina ?cantidadV
      $?finV ;; lista con vagones
    finVagon
    iniMaletas
      $?iniM ;; lista con maletas
        ?mx ?posicionM
      $?finM ;; lista con maletas
    finMaletas
  )
  (maleta ?mx ?pesoM ?destinoM)
  (vagon ?vx ?pesoMin ?pesoMax)
  (test (<= ?pesoMin ?pesoM))
  (test (>= ?pesoMax ?pesoM))
  =>
  (assert (state maquina ?posicionM ocupada
    iniVagon
      $?iniV ;; lista con vagones
        ?vx maquina (+ 1 ?cantidadV)
      $?finV ;; lista con vagones
    finVagon
    iniMaletas
      $?iniM ;; lista con maletas
        ?mx ?vx
      $?finM ;; lista con maletas
    finMaletas
  ))
)

;; engancharVagonMaquina -> Regla que se encarga de enganchar el vagón en una máquina
;; .............................................................
;; posicionMaquina == posicionVagon
;; estadoMaquina == libre
;; cantidadV == 0
;; =>
;; posicionVagon = maquina
;; estadoMaquina = ocupada
(defrule engancharVagonMaquina
  (declare (salience 20))
  (state maquina ?posicionV libre
    iniVagon
      $?iniV ;; lista con vagones
        ?vx ?posicionV 0
      $?finV ;; lista con vagones
    finVagon
    $?maletas ;; lista con maletas
  )
  =>
  (assert (state maquina ?posicionV ocupada
    iniVagon
      $?iniV ;; lista con vagones
        ?vx maquina 0
      $?finV ;; lista con vagones
    finVagon
    $?maletas ;; lista con maletas
  ))
)

;; desengancharVagonMaquina -> Regla que se encarga de desenganchar el vagón de la maquina
;; .............................................................
;; cantidadV == 0
;; estadoMaquina == ocupada
;; posicionV == maquina
;; =>
;; posicionV = posicionMaquina
;; estadoMaquina = libre
(defrule desengancharVagonMaquina
  (state maquina ?posicionMaquina ocupada
    iniVagon
      $?iniV ;; lista con vagones
        ?vx maquina 0
      $?finV ;; lista con vagones
    finVagon
    $?maletas ;; lista con maletas
  )
  =>
  (assert (state maquina ?posicionMaquina libre
    iniVagon
      $?iniV ;; lista con vagones
        ?vx ?posicionMaquina 0
      $?finV ;; lista con vagones
    finVagon
    $?maletas ;; lista con maletas
  ))
)

;; acabaPrograma -> Regla que se encarga de acabar el programa
;; .............................................................
;; ... iniMaletas $?maletas finMaletas
;; length($?maletas) == 0
;; =>
;; acabar el programa
(defrule acabaPrograma
  (declare (salience 100))
  (state $?estado
    iniMaletas
      $?maletas ;; lista con maletas
    finMaletas
  )
  (test (= 0 (length $?maletas)))
  =>
  (printout t "SOLUCION ENCONTRADA")
  (halt)
)