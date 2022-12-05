Code.require_file "alumno.exs", __DIR__
Code.require_file "profesor.exs", __DIR__
Code.require_file "lista.exs", __DIR__

defmodule Main do
  IO.puts "------ Main running -------"
#levanta lista
  lista = Lista.start
  IO.puts "Lista: " <> inspect(lista)
#levanta alumnos
  alumno1 = Alumno.start(lista)
  IO.puts "Alumno: " <> inspect(alumno1)
  alumno2 = Alumno.start(lista)
  IO.puts "Alumno: " <> inspect(alumno2)
  alumno3 = Alumno.start(lista)
  IO.puts "Alumno: " <> inspect(alumno3)
#levanta profesor
  profesor = Profesor.start(lista)
  IO.puts "Profesor: " <> inspect(profesor)
  :timer.sleep(10000000)
  
end
