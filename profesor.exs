defmodule Profesor do
  IO.puts "Profesor: loaded."
  def start(list) do
    spawn_link(fn -> init(list) end)
  end

  def init(list) do
    conectarseALaLista list
    loop()
  end

  def loop() do
    receive do
      {lista,consulta,:nuevaConsulta} ->
        IO.puts "Hay una nueva consulta" <> consulta
        send lista,{self(),consulta,:profesorEmpiezaEscribir}
        :timer.sleep(200)
        send lista,{self(),consulta,"respuesta",:profesorResponde}
        loop()
      {_lista, _mensaje, _respuesta,:nuevaRespuesta} ->
        IO.puts 'Un profesor responde'
        loop()
      {_lista, mensaje,:profesorEmpiezaEscribir} ->
        IO.puts "Otro profesor empezo a escribir para" <> mensaje
        loop()
      {_lista, _ } ->
        IO.puts 'Mensaje invalido'
        loop()
    end
  end

  def conectarseALaLista list do
    send list, {self(), :profesorSeConecta}
  end
end
