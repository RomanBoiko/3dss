-module(db).

-export([init/0,start/0,create_user_session/5, get_user_session/1,
         update_user_session/2,get_all_user_sessions/0]).

-include("../include/entities.hrl").

%% status: '0'-not started, '1'-finished, 'x'-started by x, 'o'-started by o

start() -> 
    init(),
    io:format(">>> DB schema created", []).

init() -> init([node()]).
    
init(NodeList) ->
    mnesia:create_schema(NodeList),
    mnesia:start(),
    
    mnesia:create_table(unique,
                        [{attributes, record_info(fields, unique)},
                         {disc_copies, NodeList}]),
    mnesia:create_table(user_session,
                        [{attributes, record_info(fields, user_session)},
                         {disc_copies, NodeList}]),
    
    mnesia:wait_for_tables([user_session], 10000).


create_user_session(Ad_id,Remote_addr,Http_user_agent,Http_referer,Http_accept_language) ->
    Id = mnesia:dirty_update_counter(unique, user_session, 1),
    Session = #user_session{id=Id,ad_id=Ad_id,remote_addr=Remote_addr,http_user_agent=Http_user_agent,http_referer=Http_referer,http_accept_language=Http_accept_language},
    F = fun() ->
                mnesia:write(Session)
        end,
    {atomic, _} = mnesia:transaction(F),
    Id.

get_user_session(Id) ->
    F = fun() ->
                mnesia:read(user_session, Id, read)
        end,
    {atomic, [Head|_]} = mnesia:transaction(F),
    Head.

update_user_session(Id, Ad_id) ->
    F = fun() -> 
                [P] = mnesia:wread({user_session, Id}),
                mnesia:write(user_session, P#user_session{ad_id=Ad_id}, write)
        end,
    {atomic, Value} = mnesia:transaction(F),
    Value.

get_all_user_sessions() ->
    F = fun() ->
                mnesia:foldl(fun(X,Acc) -> [X|Acc] end, [], user_session)
        end,
    {atomic, Value} = mnesia:transaction(F),
    Value.
