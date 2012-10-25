-module(statistics_request_handler).
-export([session_statistics/3]).

-include("../include/entities.hrl").

session_statistics(SessionID, _Env, _Input) ->
    UserSessions = db:get_all_user_sessions(),
    io:format(">>>SESSIONS>>>>=~s~n", [format_sessions(UserSessions)]),
    mod_esi:deliver(SessionID,[format_sessions(UserSessions)]).


format_session(User_session) ->
    lists:flatten(io_lib:format("Ad: ~s, remote ip: ~s, users browser compatibility: ~s, source page: ~s, user language: ~s", 
                                [User_session#user_session.ad_id,User_session#user_session.remote_addr,User_session#user_session.http_user_agent,User_session#user_session.http_referer,User_session#user_session.http_accept_language])).


format_sessions(SessionRecords) ->
    string:join(lists:map(fun format_session/1, SessionRecords), "<br/>").
