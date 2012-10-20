-module(rest).
-export([login/3]).

login(SessionID, _Env, _Input) ->
    mod_esi:deliver(SessionID,["{'widget': 1}"]).
