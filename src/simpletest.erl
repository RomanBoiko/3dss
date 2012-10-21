-module(simpletest).

-export([start_link/0]).
-export([set/1, add/1]).

-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

set(Value) ->
    gen_server:call(?MODULE, {set, Value}).

add(Value) ->
    gen_server:call(?MODULE, {add, Value}).

init(_Args) ->
    {ok, 0}.

handle_call({set, Value}, _From, _Accumulator) ->
    {reply, {ok, Value}, Value};
handle_call({add, Value}, _From, Accumulator) ->
    Accumulator1 = Accumulator + Value,
    {reply, {ok, Accumulator1}, Accumulator1}.

handle_cast(_Request, Accumulator) ->
    {noreply, Accumulator}.

handle_info(_Request, Accmulator) ->
    {noreply, Accmulator}.

terminate(_Reason, _State) ->
    ok.