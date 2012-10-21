-module(statistics_request_handler).
-export([login/3]).

login(SessionID, _Env, _Input) ->
    mod_esi:deliver(SessionID,["[server] Statistics is not available yet"]).
