function clear() #Limpia pantalla dependiendo de la terminal
    run(Sys.isunix() ? `clear` : `cmd /c cls`)
end

function input(msg) #Función de input, con mensaje personalizado
    print(msg) #Imprime el mensaje
    readline() #Pide datos
end

function validaCoord(str)
    if !(length(str) == 2) || !(isdigit(str[1])) || !(isletter(str[2]))
        return false
    end
    return true
end

function imprime(mtx)
    clear()
    println("    a b c d e f g h i j")
    println("  ,--------------------")
    for j in 1:size(mtx, 1)
        print(j - 1, " | ")
        for i in 1:size(mtx, 2)
            print(mtx[j, i], " ")
        end
        println()
    end
    println("\n")
end

function xy(coor)
    x = Int(coor[2]) - 96
    y = parse(Int, coor[1]) + 1
    return x, y
end

function buscaIguales(x, y, matrix, val)
    if val == matrix[y, x]
        push!(conj, parse(Int, string(y - 1, x - 1)))
        matrix[y, x] = 0
        if x > 1
            buscaIguales(x - 1, y, matrix, val)
        end
        if y > 1
            buscaIguales(x, y - 1, matrix, val)
        end
        if x < 10
            buscaIguales(x + 1, y, matrix, val)
        end
        if y < 10
            buscaIguales(x, y + 1, matrix, val)
        end
    end
end

function revisaLinea3(c1)
    if length(c1) < 3
        return false
    end
    for i in c1
        if in(i + 1, c1) && in(i + 2, c1)
            return true
        end
        if in(i + 10, c1) && in(i + 20, c1)
            return true
        end
    end
    return false
end

function subeCeros(mtx)
    println("Sube")
    for j in size(mtx, 1):-1:1
        for i in 1:size(mtx, 2)
            if (mtx[j, i] == 0) && j > 1
                for n in j-1:-1:1
                    if !(mtx[n, i] == 0)
                        mtx[j, i], mtx[n, i] = mtx[n, i], 0
                        break
                    end
                end
            end
        end
    end
end

function restauraMatrix(mtx, v)
    for i in conj
        i = string(i)
        if length(i) == 1
            mtx[1, parse(Int, i) + 1] = v
        else
            mtx[parse(Int, i[1]) + 1, parse(Int, i[2]) + 1] = v
        end
    end

end

score = 0
conj = Int[]

function main()
    matrix = rand(1:5, 10, 10)
    coor = ""

    lifes = 5
    while lifes > 0
        while true
            imprime(matrix)
            coor = input("Ingresa coordenadas (0a): ")
            if validaCoord(coor)
                break
            end
        end

        global conj = Int[]
        x, y = xy(coor)
        val = matrix[y, x]
        buscaIguales(x, y, matrix, matrix[y, x])
        imprime(matrix)
        if revisaLinea3(conj)
            subeCeros(matrix)
            global score += 100 * length(conj)
        else
            restauraMatrix(matrix, val)
        end
        imprime(matrix)
        lifes -= 1
    end
    println("Puntaje Final: ", score)
end

main()
