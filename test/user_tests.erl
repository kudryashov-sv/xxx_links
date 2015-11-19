-module(user_tests).

-include_lib("eunit/include/eunit.hrl").

-define(NO_NAME_MESSAGE, <<"User should have name">>).
-define(NO_AGE_MESSAGE, <<"User should have age">>).
-define(AGE_18_PLUS_MESSAGE, <<"User should be 18+">>).
-define(NO_EMAIL_MESSAGE, <<"No email, no porn links">>).
-define(INVALID_EMAIL_MESSAGE, <<"Invalid email, no porn links">>).

-define(GOOD_USER, [
    {name, <<"Petr">>},
    {age, 18},
    {email_for_porn_links, <<"petr@mail.ru">>}
]).

validate_test_() ->
    {inparallel, 8, [
        [{lists:flatten(io_lib:format("module '~s' tests", [Module])), [
            {"User should be okay, if all okay", ?_test(user_ok(Module))},
            {"User should have name", ?_test(user_name_exists(Module))},
            {"User should have age", ?_test(user_age_exists(Module))},
            {"User should be 18+", ?_test(user_age_18_plus(Module))},
            {"User should have valid email for porno links", ?_test(user_email_exists(Module))}
        ]}
        ] || Module <- ['01_very_bad', '02_fucrs', '03_bad', '04_good']
    ]}.

user_ok(Module) ->
    ?assertMatch(ok, Module:validate(?GOOD_USER)).

user_name_exists(Module) ->
    check_validation_error(
        Module,
        lists:keydelete(name, 1, ?GOOD_USER),
        ?NO_NAME_MESSAGE).

user_age_exists(Module) ->
    check_validation_error(
        Module,
        lists:keydelete(age, 1, ?GOOD_USER),
        ?NO_AGE_MESSAGE).

user_age_18_plus(Module) ->
    check_validation_error(
        Module,
        lists:keyreplace(age, 1, ?GOOD_USER, {age, 10}),
        ?AGE_18_PLUS_MESSAGE).

user_email_exists(Module) ->
    EmailTag = email_for_porn_links,
    check_validation_error(
        Module,
        lists:keydelete(EmailTag, 1, ?GOOD_USER),
        ?NO_EMAIL_MESSAGE),

    check_validation_error(
        Module,
        lists:keyreplace(EmailTag, 1, ?GOOD_USER, {EmailTag, <<"bad email">>}),
        ?INVALID_EMAIL_MESSAGE
    ).

check_validation_error(Module, User, ExpectedError) ->
    Result = Module:validate(User),
    try
        ?assertMatch({false, _}, Result),
        ?assert(lists:member(ExpectedError, element(2, Result)))
    catch
        Class : {Tag, Error} when Tag == assertion_failed; Tag == assertMatch_failed ->
            UpdatedError = [
                {expected_message, ExpectedError},
                {user, User},
                {result, Result} | Error
            ],
            erlang:raise(Class, {Tag,UpdatedError} , erlang:get_stacktrace());
        Class:Error ->
            erlang:raise(Class, Error, erlang:get_stacktrace())
    end.
