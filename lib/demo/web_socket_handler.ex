defmodule Demo.WebSocketHandler do
  @behaviour :cowboy_websocket

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(opts) do
    IO.puts("init")
    Phoenix.PubSub.subscribe(:chat_pubsub, "mytopic")
    {:ok, opts}
  end

  def websocket_handle({:text, content}, opts) do
    Phoenix.PubSub.broadcast(:chat_pubsub, "mytopic", {:text, content})
    {:ok, opts}
  end
  def websocket_handle(_frame, opts) do
    # IO.inspect()
    IO.puts("invalid message")
    {:ok, opts}
  end

  def websocket_info({:text, content}, opts) do
    {:reply, {:text, content}, opts}
  end
  def websocket_info(_info, opts) do
    {:ok, opts}
  end

  def terminate(_reason, _req, _opts) do
    IO.puts("terminate")
    Phoenix.PubSub.unsubscribe(:chat_pubsub, "mytopic")
    :ok
  end
end
