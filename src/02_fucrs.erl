-module('02_fucrs').

-export([validate/1]).

-spec validate([types:user_field()]) -> ok | {false, [binary()]}.
validate(User) ->
    validate_name(User).

validate_name(User) ->
    UserName = proplists:get_value(name, User),
    validate_name(UserName, User).

validate_name(undefined, _User) ->
    {false, [<<"User should have name">>]};
validate_name(Name, User) when is_binary(Name) ->
    validate_age(User).

validate_age(User) ->
    Age = proplists:get_value(age, User),
    validate_age(Age, User).

validate_age(undefined, _User) ->
    {false, [<<"User should have age">>]};
validate_age(Age, User) when is_integer(Age) ->
    validate_age_18_plus(Age, User).

validate_age_18_plus(Age, _User) when Age < 18 ->
    {false, [<<"User should be 18+">>]};
validate_age_18_plus(_Age, User) ->
    validate_email(User).

validate_email(User) ->
    Email = proplists:get_value(email_for_porn_links, User),
    validate_email(Email, User).

validate_email(undefined, _User) ->
    {false, [<<"No email, no porn links">>]};
validate_email(Email, _User) when is_binary(Email) ->
    validate_email_format(Email).

validate_email_format(Email) ->
    Match = re:run(Email, "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"),
    validate_email_format1(Match).

validate_email_format1({match, _}) ->
    ok;
validate_email_format1(nomatch) ->
    {false, [<<"Invalid email, no porn links">>]}.
