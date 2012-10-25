-module(db).

-export([init/0,start/0,create_user_session/2, get_user_session/1,
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
    
    mnesia:create_table(user_session,
                        [{attributes, record_info(fields, user_session)},
                         {disc_copies, NodeList}]),
    
    mnesia:wait_for_tables([user_session], 10000).


create_user_session(Ad_id, User_http_request_details) ->
    Id = mnesia:dirty_update_counter(unique, user_session, 1),
    Session = #user_session{id=Id,ad_id=Ad_id,user_http_request_details=User_http_request_details},
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
                Session = #user_session{id = '$1', _ = '_'},
                mnesia:select(user_session, [{Session, [], ['$1']}])
        end,
    {atomic, Value} = mnesia:transaction(F),
    Value.
