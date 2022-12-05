defmodule Alumno do
  IO.puts "Alumno: loaded."
  def start(list) do
    spawn_link(fn -> init(list) end)
  end

  def init(list) do
    conectarseALaLista list
    spawn_link(fn -> loopPublicar(list, self()) end)
    loop()
  end

  def loop() do
    receive do
      {_pid, consulta, respuesta, :nuevaRespuesta} ->
        IO.puts "Hay una nueva respuesta: " <> respuesta <> " a: " <> consulta
        loop()
      {_pid, mensaje, :nuevaConsulta} ->
        IO.puts "Un alumno mando: " <> mensaje
        loop()
    end
  end

  def loopPublicar(list, alumnoReceptor) do
    send list, {alumnoReceptor, "hello world", :nuevoMensaje}
    :timer.sleep(2000)
    loopPublicar(list, alumnoReceptor)
  end

  def conectarseALaLista list do
    send list, {self(), :alumnoSeConecta}
  end
end
