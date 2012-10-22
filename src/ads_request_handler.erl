-module(ads_request_handler).
-export([register_client/3]).

register_client(SessionID, Env, Input) ->
    io:format(">>register_client: sessionId=~w, input=~s, env=~w ~n", [SessionID, http_uri:decode(Input), Env]),
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
