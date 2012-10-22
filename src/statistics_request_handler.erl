-module(statistics_request_handler).
-export([session_statistics/3]).

session_statistics(SessionID, _Env, _Input) ->
    mod_esi:deliver(SessionID,["[server] Statistics is not available yet"]).
