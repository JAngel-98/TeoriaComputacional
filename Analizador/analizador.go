package main

import(
	"fmt"
	"bufio"
	"os"
	"regexp"
)

//Expresiones Regulares utilizadas
const LIBRERIAS = `\s*#include\s*<[a-z|A-Z]*\.(h>)$`
const COMENTARIO = `(//\s*.*)`
const FUNCIONES = `^[int\s]*[a-z|A-Z|0-9]+(\(\))$`
const FUNCIONES2 = `[a-z]+\s*\((\s*\"[\s|\d|\w|\\|%d]*\"\s*(,\s*&[a-z]+)*\s*)*\)(\{)*;`
const CORCHETES = `\s*[{|}]+\s*`
const VARIABLES = `\s*(int|float|char|bool)\s*[a-z|A-Z|0-9]*;`
const CICLOS = `(\s*for\s*\(\s*[a-zA-Z]+\s*=\s*\d+\s*;\s*[a-zA-Z]+\s*[<>=!]{1,2}\s*(\d+|[a-zA-Z]+)\s*;\s*[a-zA-Z]+\s*(([+]{2,2})|([-]{2,2})|([+-]\d+)|(\s*=\s*[a-zA-Z]+[+-]\d+))\s*\))`
const CONDICIONALES = `(\s*if\s*\((((\s*\d+\s*))|(\s*[a-zA-Z]+\d*\s*)|([a-zA-Z]+\s*(([%\/\*\^]\s*\d+\s*[<>=!])|([<>=!])*)=\s*(([a-zA-Z]+\d*)|(\d+))*\s*))\))`
const RESERVADAS = `\s*(return\s+\d*\s*);\s*`
const JUMP = `^\s*$`


func main(){

	archivo, err := os.Open("fichero1.cpp")//abre el fichero
	falloexp := false//variable para el manejo de la validacion de cada expresion regular
	if(err!=nil){//Si hay algun error al abrir el archivo
		fmt.Printf("Error")
		return
	}

	scanner := bufio.NewScanner(archivo)
	c := 0
	for scanner.Scan(){
		falloexp = false
		linea := scanner.Text()//Registra cada reglon del archivo
		//fmt.Println(linea)
		//Validacion de cada expresion regular con la linea
		regExplibrerias, err := regexp.Match(LIBRERIAS, []byte(linea))
		regExpcomentarios, err2 := regexp.Match(COMENTARIO, []byte(linea))
		regExpfunciones, err3 := regexp.Match(FUNCIONES, []byte(linea))
		regExpcorchetes, err4 := regexp.Match(CORCHETES, []byte(linea))
		regExpvariables, err5 := regexp.Match(VARIABLES, []byte(linea))
		regExpfunciones2, err6 := regexp.Match(FUNCIONES2, []byte(linea))
		regExpCiclos, err7 := regexp.Match(CICLOS, []byte(linea))
		regExpcondicionales, err8 := regexp.Match(CONDICIONALES, []byte(linea))
		regExpreservadas, err9 := regexp.Match(RESERVADAS, []byte(linea))
        regJump, err9 := regexp.Match(JUMP, []byte(linea))
        
        
        fmt.Println(linea)
		//Registro de errores en cada variable de expresion regular
		if(err!=nil && err2!=nil && err3!=nil && err4!=nil && err5!=nil && err6!=nil && err7!=nil && err8 != nil && err9 != nil){
			fmt.Println("Error en la expresion")
			return
		}
			if(regExplibrerias){//Validación librerias-expReg
				
				continue
			}else{
				
				falloexp = true
			}
			if(regExpcomentarios){//Validación comentarios-expReg
				
				continue
			}else{
				
				falloexp = true
			}	
			if(regExpfunciones){//Validación funciones-expReg
				
				continue
			}else{
				
				falloexp = true
			}
			if(regExpcorchetes)	{//Validación corchetes-expReg
				c++
				continue
			}else{
				falloexp = true
			}
			if(regExpvariables){//Validación variables-expReg
				continue
			}else{
				
				falloexp = true
			}
			if(regExpfunciones2){//Validación otras funciones y expReg
				continue
			}else{
				
				falloexp = true
			}
			if(regExpCiclos){//Validación ciclo for expReg
				continue
			}else{
				
				falloexp = true
			}
			if(regExpcondicionales){//Validación de condicional if
				continue
			}else{
				falloexp = true
				
			}
			if(regExpreservadas){//Validación de palabras reservadas
				continue
			}else{
				
				falloexp = true
			}
			if(regJump){//Validación de linas en blanco
				continue
			}else{
				
				falloexp = true
			}
			if(falloexp){//en caso de que todas hallan fallado, salir de for
				fmt.Println("No cumple la expresion")
				return
			}
	}
	fmt.Println("Cumple la expresion")
}

