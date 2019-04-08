rm *.tap
pasmo --bin wakawaka.s wakawaka.b
pasmo --tapbas wakawaka.s wakawaka.tap
ls -lag *.b
