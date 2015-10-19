%%%-------------------------------------------------------------------
%%% @author niney
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 10월 2015 오전 11:23
%%%-------------------------------------------------------------------
-module(user2_handler).
-author("niney").

%% API
-export([]).

%% Standard callbacks for the behaviour.
-export([init/3]).
-export([rest_init/2]).
-export([terminate/3]).
-export([handle/2]).
-export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).

%% Custom callbacks for my app.
-export([handle_get/2]).
-export([handle_post/2]).
-export([delete_resource/2]).
-export([delete_completed/2]).

% This starts up every time someone invokes the endpoint, whether that is GET, POST and so on
init(_, _, _) ->
  io:format("init: got here!~p~n", ["d"]),
  {upgrade, protocol, cowboy_rest}.

rest_init(Req, Opts) ->
  io:format("rest init: got here!~p~n", ["d"]),
  {Method, Req1} = cowboy_req:method(Req),
  State = Method,
  {ok, Req1, State}.

% Another function where you can intercept the call in the pipeline
handle(Req, State) ->
  io:format("handle !!!!!!!!!!!!!!!!!!!!!!! ~p", ["d"]),
  {ok, Req, State}.

% A function that gets called if the behaviour was terminated.
terminate(_Reason, _Req, _State) ->
  ok.

% This is a function that tells what methods are allowed for an end point
allowed_methods(Req, State) ->
  io:format("allowed_methods: got here!~p~n", ["d"]),
  {[<<"GET">>, <<"POST">>, <<"PUT">>, <<"DELETE">>], Req, State}.

% This is called on GET typically and calls a function based on the calls Content-Type
content_types_provided(Req, State) ->
  io:format("content_types_provided: got here!~p~n", ["d"]),
  {[
    {<<"application/json">>, handle_get}
  ], Req, State}.

% This is called on Post typically and calls a function based on the calls Accept
content_types_accepted(Req, State) ->
  io:format("content_types_accepted: got here!~p~n", ["d"]),
  {[
    {{<<"application">>, <<"json">>, []}, handle_post}
  ], Req, State}.

delete_resource(Req, State) ->
  io:format("delete_resource ~p~n", ["d"]),
  {true, Req, State}.

delete_completed(Req, State) ->
  io:format("delete_completed ~p~n", ["d"]),
  Body = <<"{\"rest\": \"Hello World!\"}">>,
  Req2 = cowboy_req:set_resp_body(Body, Req),
  {true, Req2, State}.

% This is what the GET call does.
% This is just returning a json object
handle_get(Req, State) ->
  io:format("Handle_get: got here!~p~n", ["d"]),
  Body = jsx:encode([{<<"library">>,<<"jsx">>},{<<"awesome">>,true},{<<"IsAwesome">>,<<"ME">>}]),
  {Body, Req, State}.

% This is what the POST call does.
% This is just returning a json object
handle_post(Req, State) ->
  io:format("Handle_post: got here!~p~n", ["d"]),
  %{ok, Body, Req2} = cowboy_req:body(Req),
  {ok, _, Req2} = cowboy_req:body(Req),
  Body = jsx:encode([{<<"library">>,<<"derp">>},{<<"awesome">>,<<"nerp">>},{<<"IsAwesome">>,<<"ME">>}]),
%%   io:format("State prt ~p~n", [cowboy_req:body(Req)]),
  Req3 = cowboy_req:set_resp_body(Body, Req2),
  {true, Req3, State}.