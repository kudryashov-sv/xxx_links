-module('04_good').

-export([validate/1]).

-define(EMAIL_REGEX, "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$").

-spec validate([types:user_field()]) -> ok | {false, [binary()]}.
validate(User) ->
    comp(ok, [
        validate_name(User),
        validate_age(User),
        validate_age_18_plus(User),
        validate_email(User),
        validate_email_format(User)
    ]).

validate_name(User) ->
    case proplists:get_value(name, User) of
        undefined ->
            error_fun(<<"User should have name">>);
        _ ->
            fun no_error/1
    end.

validate_age(User) ->
    case proplists:get_value(age, User) of
        undefined ->
            error_fun(<<"User should have age">>);
        Age when is_integer(Age) ->
            fun no_error/1
    end.

validate_age_18_plus(User) ->
    case proplists:get_value(age, User) of
        Age when is_integer(Age), Age < 18 ->
            error_fun(<<"User should be 18+">>);
        _ ->
            fun no_error/1
    end.

validate_email(User) ->
    case proplists:get_value(email_for_porn_links, User) of
        undefined ->
            error_fun(<<"No email, no porn links">>);
        _ ->
            fun no_error/1
    end.

validate_email_format(User) ->
    Email = proplists:get_value(email_for_porn_links, User, <<"">>),
    case re:run(Email, ?EMAIL_REGEX) of
        {match, _} ->
            fun no_error/1;
        nomatch ->
            error_fun(<<"Invalid email, no porn links">>)
    end.

no_error(Acc) -> 
    Acc.

error_fun(Message) ->
    fun(AccIn) ->
        append_error(Message, AccIn)
    end.

append_error(Error, ok) ->
    {false, [Error]};
append_error(Error, {false, Errors}) ->
    {false, [Error | Errors]}.

comp(Initial, Funs) ->
    lists:foldl(
        fun(Fun, AccIn) ->
            Fun(AccIn)
        end,
        Initial,
        Funs).
