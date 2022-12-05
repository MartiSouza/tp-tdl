defmodule Lista do

  IO.puts "Lista: loaded."
  def start do
    map=%{}
    map=Map.put(map,:alumnos,[])
    map=Map.put(map,:profesores,[])
    map=Map.put(map,:mensajes,[])
    spawn_link(fn -> loop(map) end)
  end

  def loop(map) do
    alumnos=Map.get(map,:alumnos)
    profesores=Map.get(map,:profesores)
    receive do
      {pid, :alumnoSeConecta} ->
        IO.puts "Un alumno se conecto"
        map=Map.put(map,:alumnos,alumnos ++ [pid])
        loop(map)
      {pid, :profesorSeConecta} ->
        IO.puts "Un profesor se conecto"
        map=Map.put(map,:profesores,profesores ++ [pid])
        loop(map)
      {_pid, mensaje, :nuevoMensaje} ->
        IO.puts "Un alumno mando: " <> mensaje
        sendNuevoMensaje(alumnos,mensaje)
        sendNuevoMensaje(profesores,mensaje)
        loop(map)
      {pid, consulta, :profesorEmpiezaEscribir} ->
        IO.puts "Un prof empezo a escribir una respuesta a: " <> consulta
        sendEmpezoEscribir(profesores,pid,consulta)
        loop(map)
      {_pid, mensaje, respuesta, :profesorResponde} ->
        IO.puts "Un profesor respondio: " <> respuesta
        sendNuevaRespuesta(alumnos,mensaje,respuesta)
        sendNuevaRespuesta(profesores,mensaje,respuesta)
        loop(map)
    end
  end

  def sendNuevoMensaje([head|tail],mensaje) do
    IO.puts "Se envio consulta " <> mensaje <> " a " <> inspect(head)
    send head,{self(),mensaje,:nuevaConsulta}
    sendNuevoMensaje(tail,mensaje)
  end

  def sendNuevoMensaje([],mensaje) do
    IO.puts "Se termino de enviar consulta " <> mensaje
  end

  def sendNuevaRespuesta([head|tail],mensaje,respuesta) do
      IO.puts "Se envio respuesta " <> mensaje <> " a " <> inspect(head)
    send head,{self(),mensaje,respuesta,:nuevaRespuesta}
    sendNuevaRespuesta(tail,mensaje,respuesta)
  end

  def sendNuevaRespuesta([],mensaje,respuesta) do
    IO.puts "Se termino de enviar respuesta " <> respuesta <> " al mensaje " <> mensaje
  end

  def sendEmpezoEscribir([head|tail],pid,mensaje) do
    IO.puts "Se envio notificacion de empezar a escribir respuesta a  " <> mensaje <> " a " <> inspect(head)
    send head,{self(),mensaje,:profesorEmpiezaEscribir}
    sendEmpezoEscribir(tail,pid,mensaje)
  end

  def sendEmpezoEscribir([],_pid,mensaje) do
    IO.puts "Se termino de enviar notificacion de empezar a escribir respuesta a " <> mensaje
  end

end
