-module(ads_request_handler).
-export([register_client/3]).

-include("../include/entities.hrl").

register_client(SessionID, Env, Input) ->
    io:format(">>register_client: sessionId=~w, input=~s, env=~w ~n", [SessionID, http_uri:decode(Input), Env]),
    UserSessionId=persist_user_session(Input, Env),
    io:format(">>>SESSION=~w~n", [db:get_user_session(UserSessionId)]),
    print_http_options(Env),
    mod_esi:deliver(SessionID,["ok"]).

print_http_options([{OptionName, OptionValue} | RestOfOptions]) when is_number(OptionValue) or is_port(OptionValue) ->
    io:format(">>>>~w:~w~n", [OptionName, OptionValue]),
    print_http_options(RestOfOptions);
print_http_options([{OptionName, OptionValue} | RestOfOptions]) ->
    io:format(">>>>~w:~s~n", [OptionName, http_uri:decode(OptionValue)]),
    print_http_options(RestOfOptions);
print_http_options([])->
   ok.

persist_user_session(Input,Env)->
    UserSessionId = db:create_user_session(http_uri:decode(Input),get_env(remote_addr,Env),get_env(http_user_agent,Env),get_env(http_referer,Env),get_env(http_accept_language,Env)),
    UserSessionId.

get_env(Key, [{Key, Value}|_]) ->
    Value;
get_env(Key, [_|EnvTail]) ->
    get_env(Key,EnvTail);
get_env(Key, []) ->
    "-".