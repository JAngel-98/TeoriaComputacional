# Leer un fichero de texto
my $filename = 'fichero.cpp';#$filename hace referencia al archivo que se va a leer llamado fichero.cpp el cual contiene un codigo para calcular numeros del 44 al 64 multiplos de 4
my $c=0;#Variable que sirve como contador y que acumula la cantidad de llaves '{' para comparar si existen la misma cantidad de llaves '}'en el codigo
my @keys;#Arreglo que sirve para almacenar las llaves '{' y '}' del documento
open INFILE,$filename;#Se abre el archivo para leer
my $linea;#Variable que servira para recorrer el archivo
while ( $linea = <INFILE>) {#Mientras $linea se mantenga dentro del archivo 'ficher.cpp' se seguira recorriendo este linea por linea
    chomp($linea); #Quita el salto de linea de la linea del archivo para leer solo el texto
    if($linea =~ m{(^#include\s*<[a-zA-Z]+\.h>)})#Se valida que las librerias cumplan con la forma #include<???.h> siendo ? un caracter del alfabeto y si es correcto procede a imprimer la linea
    {
        print "$1\n";#La variable $1 es una variable local de perl que se genera al realizar una comparacion con una expresio regular, y con la expresion '=~ m{()}' la cual almacenara el resultado que se encuentre encerrado en los parentesis.
    }
    elsif ($linea =~ m{(//\s*.*)})#Se validan los comentarios que tengan en la linea un '//... ' Siendo el . Algun caracter de cualquier tipo
    {
        print "$1\n";
    }
    elsif ($linea =~ m{(^(int\s)*main\(\))})#Valida que se tenga ya se un 'int main()' o un 'main()' ya que ambos son validos en C
    {
        print "$1\n";
        while ( $linea = <INFILE>) {#Una vez que se valida que se este dentro del main se procede a validar las llaves de apertura y cierre '{' y '}' en la linea 22 y se ejecuta otro while para continuar leyendo donde mismo en el archivo
            chomp($linea);
            if($linea =~ m{(\{|\})})#Aqui se validan las llaves y una vez que detecta una esta se almacena en el arreglo  '@keys'
            {
                print "$linea\n";
                push(@keys,$1);#Se inserta con un push en el arreglo el resultado de la comparación de la expresion regular que como ya se menciono se almacena en $1
            }
            elsif ($linea =~ m{(//\s*.*)})#Se valida de nuevo un comentario dentro de todo el main
            {
                print "$1\n";
            }
            elsif($linea =~ m{(\s*(int|float|char)\s+[a-zA-Z]+\s*[=]*\s*(([a-zA-Z]+\d*)|(\d+))*;)})#Se valida la declaracion de variables con los tipos int o float o char con la sig forma (int a; | float b1=a; | int a=1;)
            {
                print "$1\n";
            }
            elsif($linea =~ m{(\s*for\s*\(\s*[a-zA-Z]+\s*=\s*\d+\s*;\s*[a-zA-Z]+\s*[<>=!]{1,2}\s*(\d+|[a-zA-Z]+)\s*;\s*[a-zA-Z]+\s*(([+]{2,2})|([-]{2,2})|([+-]\d+)|(\s*=\s*[a-zA-Z]+[+-]\d+))\s*\))})
            {#Se valida la forma del for de la siguientes formas (for[Espacios en blanco pueden o no estar](var=1 ; var1 [< | > | = | >= | <= | !=] 9 ó var2; var1++ | var1-- | var+2 | var-2 | var=var+1 )
                print "$1\n";
            }
            elsif($linea =~ m{(\s*if\s*\((((\s*\d+\s*))|(\s*[a-zA-Z]+\d*\s*)|([a-zA-Z]+\s*(([%\/\*\^]\s*\d+\s*[<>=!])|([<>=!])*)=\s*(([a-zA-Z]+\d*)|(\d+))*\s*))\))}){
                print "$1\n";#Se valida la forma del if como if(var) | if(1) | if(var == 2) | if(var > var2) | if(var>=2)
            }
            elsif($linea =~ m{(\s*printf\s*\(((\s*["].*\s*["](,\s*&[a-zA-Z]+\s*)*))\s*\);)}){# se valida el printf con las dos variantes printf(".*"); | printf(".*", &var);
                print "$1\n";
            }
            elsif($linea =~ m{(\s*getch\s*\([a-zA-Z]*\d*\);)}){#Se valida que el getch pueda ser uno vacio o con variable dentro getch(); | getch(var1);
                print "$1\n";
            }
            elsif($linea =~ m{(\s*return\s([a-zA-Z]*\d*|\d+);)}){# Se valida que el return cumpla con la forma return var1; | return 0;
                print "$1\n";
            }
            elsif($linea =~ m{(^\s*$)}){#Se validan salots de lina en blanco
                print "$1\n";
            }
            else
            {
                print "Error en la siguiente linea\n$linea\n";# si no realiza ninguna de las expresiones entonces cae en un error y deja de imprimir el codigo y sale a la ultima linea de este codigo con goto
                goto salida;
            }
        }
    }
    else
    {#Lo mismo del error solo que aqui es antes de entrar al main
        print "Error en la siguiente linea\n$linea\n";
        goto salida;
    }
}
close INFILE;# Se cierra el archivo para evitar problemas futuros con los apuntadores
foreach $elem (@keys){#Se recorre el arreglo con la variable $elem la cual va a ir adquiriendo el valor del arreglo segun su posicion
    if($elem =~ m{^\{}){#Si el elemento en en el arreglo es una llave '{' se incrementa el contador c
        $c++;
    }
}
if($c*2 == scalar(@keys)){#Al obtener el escalar del arreglo arroja los elementos que tiene este y se compara si el contador es la mitad del arreglo entonces eso indica que la mitad son llaves que abren y la otra son llaves que cierran por ende las llaves estan completas
    print "Todas las llaves que abren tiene su cierre\n";
}
else{#Si no posiblemente sobren o falten llaves
    print "Faltan o sobran llaves\n";
}
salida: print "\n";
