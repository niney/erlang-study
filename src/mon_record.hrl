%%%-------------------------------------------------------------------
%%% @author 이국현
%%% @copyright (C) <COMPANY>
%%% @doc
%%%
%%% @end
%%%
%%%-------------------------------------------------------------------
-author("이국현").

-record(users, {
    id,
    password,
    token,
    level=0,
    exp=0,
    point=0
}).
