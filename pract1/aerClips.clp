(deffacts maletas
 (mal m1 12 p3)
 (mal m2 18 p5)
 (mal m3 20 re)
 (mal m4 14 re)
)

(deffacts vagon
  (vag t1 0 15)
  (vag t2 16 23)
)

(deffacts camino
  (cam p2 fac)
  (cam p2 p4)
  (cam p4 p2)
  (cam p4 p3)
  (cam p3 p1)
  (cam p3 p4)
  (cam p1 fac)
  (cam p1 p5)
  (cam p1 p3)
  (cam fac p2)
  (cam fac p1)
  (cam p5 p1)
  (cam p5 re)
  (cam p5 p7)
  (cam re p5)
  (cam re p6)
  (cam p7 p5)
  (cam p7 p8)
  (cam p8 p7)
  (cam p8 p6)
  (cam p6 p8)
  (cam p6 re)
)

;; estadoMaquina  -> libre  | ocupada
;; posicionVagon  -> ?nodo  | maquina
;; posicionMaleta -> ?vagon | ?nodo
(deffacts terminal
  (state
    maquina posicionMaquina estadoMaquina
    iniVagon
      t1 posicionVagon1 cantidadPesoVagon1
      t2 posicionVagon2 cantidadPesoVagon2
    finVagon
    iniMaletas
      m1 posicionMaleta1
      m2 posicionMaleta2
      m3 posicionMaleta3
  )
)

;; --------------------------------------------------------
;; Rules

;;(defrule default
;;  (state maquina ?posicionMaquina ?esatdoMaquina
;;    iniVagon
;;      $?iniV
;;        ?vx ?posicionV ?cantidadV
;;      $?finV
;;    finVagon
;;    iniMaletas
;;      $?iniM
;;        ?mx ?posicionM
;;      $?finM
;;    finMaletas
;;  )
;;  (maleta ?mx ?pesoM ?destinoM)
;;  (vagon ?vx ?pesoMin ?pesoMax)
;;)

(defrule dejarMaleta
  (state maquina ?destinoM ?esatdoMaquina
    iniVagon
      $?iniV
        ?vx maquina ?cantidadV
      $?finV
    finVagon
    iniMaletas
      $?iniM
        ?mx ?vx
      $?finM
    finMaletas
  )
  (maleta ?mx ?pesoM ?destinoM)
  =>
  (assert (state maquina ?destinoM ?esatdoMaquina
    iniVagon
      $?iniV
        ?vx maquina (- ?cantidadV ?pesoM)
      $?finV
    finVagon
    iniMaletas
      $?iniM
      $?finM
    finMaletas
  ))
)

(defrule moverMaquina
  (state maquina ?posicionMaquina ?esatdoMaquina
    iniVagon
      $?iniV
        ?vx ?posicionV ?cantidadV
      $?finV
    finVagon
    iniMaletas
      $?iniM
        ?mx ?posicionM
      $?finM
    finMaletas
  )
  (maleta ?mx ?pesoM ?destinoM)
  (vagon ?vx ?pesoMin ?pesoMax)
)