-module(application_manager).

-behaviour(application).
-export([start/2, stop/1]).

start(normal, _StartArgs) ->
    simpletest_sup:start_link().

stop(_State) ->
    ok.

%% start(normal, _StartArgs) ->
%%     io:format("==>Starting ads3dss...~n", []).
%% 
%% stop(_State) ->
%%     io:format("==>Stopping ads3dss...~n", []),
%%     ok.