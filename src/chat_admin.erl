%%%-------------------------------------------------------------------
%%% @author Niney
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 10월 2015 오후 2:09
%%%-------------------------------------------------------------------
-module(chat_admin).
-author("Niney").

-behaviour(gen_server).

%% API
-export([start_link/1, join/2, leave/2, chat/3]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-record(state, {room, users=[]}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
%% -spec(start_link() ->
%%   {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
%% start_link() ->
%%   gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
-spec(start_link(Room::term()) ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link(Room) ->
  gen_server:start_link({local, Room}, ?MODULE, [Room], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
%% -spec(init(Args :: term()) ->
%%   {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
%%   {stop, Reason :: term()} | ignore).
%% init([]) ->
%%   {ok, #state{}}.
-spec(init(Args :: term()) ->
  {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).
init([Room]) ->
  io:format("init chat_admin ~p~n",[Room]),
  {ok, #state{room=Room}}.

join(Room, User) ->
  gen_server:call(Room, {join, User}).

leave(Room, User) ->
  gen_server:call(Room, {leave, User}).

chat(Room, User, Message) ->
  gen_server:call(Room, {chat, User, Message}).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
  {reply, Reply :: term(), NewState :: #state{}} |
  {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_call({join, User}, _From, State) ->
  Users = State#state.users,
  NewUsers = Users ++ [User],
  State1 = State#state{users=NewUsers},
  {reply, {users, NewUsers}, State1};
handle_call({leave, User}, _From, State) ->
  Users = State#state.users,
  NewUsers = Users -- [User],
  State1 = State#state{users=NewUsers},
  {reply, {users, NewUsers}, State1};
handle_call({chat, User, Message}, _From, State) ->
  Reply = User ++ Message + 1,
  {reply, Reply, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
