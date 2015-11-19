-module(types).

-export_type([
    name_field/0,
    age_field/0,
    email_field/0,
    user_field/0
]).

-type name_field() :: {name, binary()}.
-type age_field() :: {age, non_neg_integer()}.
-type email_field() :: {email_for_porn_links, binary()}.

-type user_field() :: name_field() | age_field() | email_field().
