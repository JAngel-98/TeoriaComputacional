open System

  type System.Random with
  /// Generates an infinite sequence of random numbers within the given range.
  member this.GetValues(minValue, maxValue) =
      Seq.initInfinite (fun _ -> this.Next(minValue, maxValue))
   
 let mutable pts = 0
  
 let printGrid grid =
     
     

     let maxY = (Array2D.length1 grid) - 1
     let maxX = (Array2D.length2 grid) - 1

     printfn "    0 1 2 3 4 5 6 7 8 9"
     printfn "   ----------------------"

     for row in 0 .. maxY do
         printf " %d |" row 
         for col in 0 .. maxX do
             if grid.[row, col] = 1 then Console.Write("1 ")
             elif grid.[row, col] = 2 then Console.Write("2 ")
             elif grid.[row, col] = 3 then Console.Write("3 ")
             elif grid.[row, col] = 4 then Console.Write("4 ")
             elif grid.[row, col] = 5 then Console.Write("5 ")
             else Console.Write("0 ");

         Console.WriteLine()
 
 let toggleGrid (grid : int[,]) =
     Console.WriteLine()
     Console.WriteLine("Escoge casilla:")

     let maxY = (Array2D.length1 grid) - 1
     let maxX = (Array2D.length2 grid) - 1
     
     let row =
         Console.Write("Fila: ")
         Console.ReadLine() |> int
         
     let col =
         Console.Write("Columna: ")
         Console.ReadLine() |> int
      

     if (grid.[row, col] = grid.[row + 1, col]) && (grid.[row, col] = grid.[row - 1, col]) && (row <> 0) && (row <> 9) then 
        grid.[row , col] <- 0
        grid.[row + 1, col] <- 0
        grid.[row - 1, col] <- 0 

        while (grid.[0,col] <> 0) do

         for i in 0 .. 8 do 
             if (grid.[i+1,col] = 0) then
               let mutable aux = grid.[i,col]
               grid.[i,col] <- grid.[i+1,col]
               grid.[i+1,col] <- aux

        pts <- pts + 100


 let main() =

    let mutable cont = 0

    let rows = 10
    
    let cols = 10
           
    let grid = Array2D.zeroCreate<int> rows cols

    while cont < 10 do
        let mutable r = System.Random()
        let nums = r.GetValues(1, 6) |> Seq.take 10
       
       
        let nums1 =  Array.ofSeq nums

        for a in 0..9 do 
            printfn "%d " nums1.[a]
            grid.[cont,a] <- nums1.[a]

        cont <- cont + 1

    printGrid grid
     
    let mutable lives = 5
    while lives > 0 do
         printfn "Tienes %d turnos" lives
         printfn "Puntuación: %d puntos" pts
         toggleGrid grid
         printGrid grid
         lives <- lives - 1
         
     
    if pts = 500 then Console.WriteLine("FELICIDADES GANASTE")
    else Console.WriteLine("Gracias por jugar")

    
main()
Console.ReadKey() |> ignore
