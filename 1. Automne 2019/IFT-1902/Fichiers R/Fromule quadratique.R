##programmer delta
delta <- function(a,b,c){
  b^2-4*a*c
}
##programmer formule quadratique
resultat <- function(a,b,c){
  if(delta > 0){
    x_1 = ((-b+sqrt(delta))/(2*a))
    x_2 = ((-b-sqrt(delta))/(2*a))
  }
  else if(delta == 0){
    x = -b/(2*a)
  }
  else {"Il n'y a pas de racine"}
}
resultat(1,4,0)


