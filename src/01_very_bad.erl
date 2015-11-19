-module('01_very_bad').

-export([validate/1]).

-spec validate([types:user_field()]) -> ok | {false, [binary()]}.
validate(User) ->
    case proplists:get_value(name, User) of
        undefined ->
            {false, [<<"User should have name">>]};
        Value when is_binary(Value) ->
            case proplists:get_value(age, User) of
                undefined ->
                    {false, [<<"User should have age">>]};
                Age when is_integer(Age) andalso Age < 18 ->
                    {false, [<<"User should be 18+">>]};
                Age when is_integer(Age) ->
                    case proplists:get_value(email_for_porn_links, User) of
                        undefined ->
                            {false, [<<"No email, no porn links">>]};
                        Email when is_binary(Email) ->
                            case re:run(Email, "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$") of
                                {match, _} ->
                                    ok;
                                nomatch ->
                                    {false, [<<"Invalid email, no porn links">>]}
                            end
                    end
            end
    end.
