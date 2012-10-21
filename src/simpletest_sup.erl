-module(simpletest_sup).

-export([start_link/0]).

-behaviour(supervisor).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SimpleTest = {
        id,
        { simpletest, start_link, [] },
        permanent, brutal_kill, worker, [simpletest]
    },
    {ok, {{one_for_one, 3, 1000}, [SimpleTest]}}.