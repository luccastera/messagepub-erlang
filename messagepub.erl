-module(messagepub).

-behaviour(gen_server).

-export([start_link/1, stop/0, send/3]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% PUBLIC API
start_link(ApiKey) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, ApiKey, []).

send(Channel, Address, Message) ->
  gen_server:call(?MODULE, {Channel, Address, Message}, 10000).

stop() ->
  gen_server:cast(?MODULE, stop).

%% Private API
init(ApiKey) ->
  inets:start(),
  {ok, ApiKey}.

handle_call({Channel, Address, Message}, _From, ApiKey) ->
  UA = "erlang-messagepub",
  Url = "http://messagepub.com/notifications.xml",
  BasicAuth = "Basic " ++ base64:encode_to_string(ApiKey ++ ":"),
  BodyXML = "<notification><body>" ++ Message ++ "</body><recipients><recipient><position>1</position><channel>" ++ Channel ++ "</channel><address>" ++ Address ++ "</address></recipient></recipients></notification>",
  {ok, {{_HttpVer, Code, Msg}, _Headers, Body}} = http:request(post, {Url, [{"User-Agent",UA}, {"Content-Type", "text/xml"}, {"Authorization", BasicAuth}], "text/xml", BodyXML}, [], []),
  MoreInfo = case Code of
    201 -> Msg;
    _ ->   Body
  end,
  Status = case Code of
    201 -> ok;
    _ ->   error
  end,  
  {reply, {Status, Code, MoreInfo}, ApiKey};
handle_call(Request, _From, State) ->
  io:format("Call received: ~p~n", [Request]),
  {reply, ignored, State}.

handle_cast(stop, State) ->
  {stop, normal, State};  
handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  io:format("Info message received: ~p~n", [_Info]),
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("Server is stopping...~n"),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
