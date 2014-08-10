(defun costPerWattage (w)
  "Function to compute the yearly cost of running a device based on wattage"
  (interactive "p")
  (let (kw hours kwh rate costPerDay costPerYear)
    (setq kw (/ w 1000.0))
    (setq hours 24.0)
    (setq kwh (* kw hours))
    (setq rate 0.05) ; assumption, could be paramater
    (setq costPerDay (* rate kwh))
    (setq costPerYear (* costPerDay 365.2425)) ; Yea, Pope Gregory !!!
    (message "$%f is the cost per year to run a device consuming %f watts" costPerYear w)
    costPerYear
    )
)

(progn
  (setq oldDellPCWattage 100.0)
  (setq costToRunDellPC (costPerWattage oldDellPCWattage))
  (setq cuboxWattage 8.0)
  (setq costToRunCubox (costPerWattage cuboxWattage))
  (setq foo (- costToRunDellPC costToRunCubox))
  (message "$%f.2 is the approximate difference in cost per year to runn an old Dell PC vs a CUBOX" foo)
)


