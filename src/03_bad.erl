-module('03_bad').

-export([validate/1]).

-spec validate([types:user_field()]) -> ok | {false, [binary()]}.
validate(User) ->
    validate_name(User).

validate_name(User) ->
    case proplists:get_value(name, User) of
        undefined ->
            {false, [<<"User should have name">>]};
        Value when is_binary(Value) ->
            validate_age(User)
    end.

validate_age(User) ->
    case proplists:get_value(age, User) of
        undefined ->
            {false, [<<"User should have age">>]};
        Age when is_integer(Age) ->
            validate_age_18_plus(User, Age)
    end.

validate_age_18_plus(_User, Age) when Age < 18 ->
    {false, [<<"User should be 18+">>]};
validate_age_18_plus(User, _Age) ->
    validate_email(User).

validate_email(User) ->
    case proplists:get_value(email_for_porn_links, User) of
        undefined ->
            {false, [<<"No email, no porn links">>]};
        Email when is_binary(Email) ->
            validate_email_format(Email)
    end.

validate_email_format(Email) ->
    case re:run(Email, "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$") of
        {match, _} ->
            ok;
        nomatch ->
            {false, [<<"Invalid email, no porn links">>]}
    end.
