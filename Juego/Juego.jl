function clear() #Limpia pantalla dependiendo de la terminal
    run(Sys.isunix() ? `clear` : `cmd /c cls`)
end

function input(msg) #Función de input, con mensaje personalizado
    print(msg) #Imprime el mensaje
    readline() #Pide datos
end

function validaCoord(str) #Valida que el primer caracter sea numero y el segundo letra
    if !(length(str) == 2) || !(isdigit(str[1])) || !(isletter(str[2])) || Int(str[2]) - 96 > 10
        return false
    end
    return true
end

function imprime(mtx) #Imprime la matriz y el marco con las coordenadas
    clear()
    println("    a b c d e f g h i j") #Columnas
    println("  ,--------------------")
    for j in 1:size(mtx, 1)
        print(j - 1, " | ") #Numero de fila
        for i in 1:size(mtx, 2)
            print(mtx[j, i], " ") #Datos
        end
        println()
    end
    println("\n")
end

function xy(coor) #Retorna los valores en decimal de las coordenadas
    x = Int(coor[2]) - 96
    y = parse(Int, coor[1]) + 1 #Los arrays en Julia empiezan en 1
    return x, y
end

function buscaIguales(x, y, matrix, val) #Busca alrededor de una coordenada si son iguales
    if val == matrix[y, x]
        push!(conj, parse(Int, string(y - 1, x - 1))) #Agrega las coordenadas pasadas a un array
        matrix[y, x] = 0 #Asigna la casilla del array a 0, paro que no se cicle
        if x > 1 #Busca en la derecha
            buscaIguales(x - 1, y, matrix, val)
        end
        if y > 1 #Busca arriba
            buscaIguales(x, y - 1, matrix, val)
        end
        if x < 10 #Busca en la izquierda
            buscaIguales(x + 1, y, matrix, val)
        end
        if y < 10 #Busca abajo
            buscaIguales(x, y + 1, matrix, val)
        end
    end
end

function revisaLinea3(c1)
    if length(c1) < 3 #Si el numero de iguales juntos es menor a 3, no es posible
        return false
    end
    for i in c1 #El el array se buscan las coincidencias
        if in(i + 1, c1) && in(i + 2, c1) #Tres numeros consecutivos en x
            return true
        end
        if in(i + 10, c1) && in(i + 20, c1) #Tres numeros con diferencias de 10 en y
            return true
        end
    end
    return false
end

function subeCeros(mtx) #Los ceros suben
    for j in size(mtx, 1):-1:1 #Recorre toda la matriz desde abajo
        for i in 1:size(mtx, 2) #Busca en todas las columnas
            if (mtx[j, i] == 0) && j > 1 #Si es 0 y no esta en la cima...
                for n in j-1:-1:1 #Busca el primer numero distinto de 0 arriba
                    if !(mtx[n, i] == 0)
                        mtx[j, i], mtx[n, i] = mtx[n, i], 0 #Cambia el numero por el 0
                        break
                    end
                end
            end
        end
    end
end

function restauraMatrix(mtx, v) #Regresa el valor que tenia antes de ponerle 0
    for i in conj #Delas coordenadas en que habis buscado y guardado...
        i = string(i)
        if length(i) == 1
            mtx[1, parse(Int, i) + 1] = v
        else
            mtx[parse(Int, i[1]) + 1, parse(Int, i[2]) + 1] = v
        end
    end

end

score = 0 #Puntaje
conj = Int[] #Conjunto de coordenadas guardadas

function main()
    matrix = rand(1:5, 10, 10) #Crea una matriz con numeros aleatorios del 1 al 5
    coor = ""

    lifes = 5 #Numero de vidas
    while lifes > 0
        imprime(matrix)
        while true #Pide las coordenadas, y valida que sea valida
            coor = input("Ingresa coordenadas (0a): ")
            if validaCoord(coor)
                break
            else
                print(" * ")
            end
        end

        global conj = Int[] #Reinicia el array de coordenadas
        x, y = xy(coor) #Coordenadas numericas
        val = matrix[y, x] #Guarda el valor que esta en la coordenada, en caso de falso
        buscaIguales(x, y, matrix, matrix[y, x]) #Busca iguales alrededor
        imprime(matrix)
        if revisaLinea3(conj) #Si hubo coincidencia de tres o mas, sube los cerosy aumenta puntaje
            subeCeros(matrix)
            global score += 100 * length(conj)
        else #Si no, restaura la matriz al valor anterior
            restauraMatrix(matrix, val)
        end
        imprime(matrix) #Imprime matriz
        lifes -= 1 #Resta una vida, haya sido cierto o falso el intento
    end
    println("Puntaje Final: ", score) #Muestra el puntaje final
end

main()
