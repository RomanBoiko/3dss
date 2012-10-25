-module(ads_request_handler).
-export([register_client/3]).

-include("../include/entities.hrl").

register_client(SessionID, Env, Input) ->
    io:format(">>register_client: sessionId=~w, input=~s, env=~w ~n", [SessionID, http_uri:decode(Input), Env]),
    User_http_request_details = #http_request_details{request_method="POST", _="_"},
    UserSessionId = db:create_user_session(http_uri:decode(Input), User_http_request_details),
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
