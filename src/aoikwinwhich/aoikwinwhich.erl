%%

uniq(Item_s) ->
    lists:foldl(
        fun(Item, Acc) ->
            ItemExists = lists:member(Item, Acc),
            if ItemExists ->
                Acc
            ;true ->
                lists:append(Acc, [Item])
            end
        end, [], Item_s).

find_executale(Prog) ->
    %% 8f1kRCu
    EnvPATHENV = os:getenv("PATHEXT"),
    %%% can be false

    %% 6qhHTHF
    %% split into a list of extensions
    Ext_s =
        if EnvPATHENV == false ->
            []
        ;true ->
            string:tokens(EnvPATHENV, ";")
        end,

    %% 2pGJrMW
    %% strip
    Ext_s2 = lists:map(fun(X) -> string:strip(X) end, Ext_s),

    %% 2gqeHHl
    %% remove empty
    Ext_s3 = lists:filter(fun(X) -> X =/= "" end, Ext_s2),

    %% 2zdGM8W
    %% convert to lowercase
    Ext_s4 = lists:map(fun(X) -> string:to_lower(X) end, Ext_s3),

    %% 2fT8aRB
    %% uniquify
    Ext_s5 = gb_sets:to_list(gb_sets:from_list(Ext_s4)),

    %% 4ysaQVN
    EnvPATH = os:getenv("PATH"),
    %%% can be false

    %% 6mPI0lg
    Dir_s =
        if EnvPATH == false ->
            []
        ;true ->
            string:tokens(EnvPATH, ";")
        end,

    %% 5rT49zI
    %% insert empty dir path to the beginning
    %%
    %% Empty dir handles the case that |prog| is a path, either relative or
    %%  absolute. See code 7rO7NIN.
    Dir_s2 = ["" | Dir_s],

    %% 2klTv20
    %% uniquify
    Dir_s3 = uniq(Dir_s2),

    %%
    ProgLc = string:to_lower(Prog),

    ProgHasExt = lists:any(fun(Ext) -> lists:suffix(Ext, ProgLc) end, Ext_s5),

    %% 6bFwhbv
    Exe_path_s_res = lists:foldl(
        fun(Dir, Acc) ->
            %% 7rO7NIN
            %% synthesize a path with the dir and prog
            Path =
                if Dir == "" ->
                    Prog
                ;true ->
                    string:join([Dir, "\\" ,Prog], "")
                end,

            %% 6kZa5cq
            %% assume the path has extension, check if it is an executable
            PathExists = filelib:is_regular(Path),

            if ProgHasExt andalso PathExists ->
                Exe_path_s = [Path]
            ;true ->
                Exe_path_s = []
            end,

            %% 2sJhhEV
            %% assume the path has no extension
            Exe_path_s2 = [
                %% 6k9X6GP
                %% synthesize a new path with the path and the executable extension
                string:concat(Path, Ext) ||
                Ext <- Ext_s5,
                %% 6kabzQg
                %% check if it is an executable
                filelib:is_regular(string:concat(Path, Ext))
            ],

            %% New Acc result
            lists:append([Acc, Exe_path_s, Exe_path_s2])

        end, [], Dir_s3),

    %% 8swW6Av
    %% uniquify
    Exe_path_s_res2 = uniq(Exe_path_s_res),

    %%
    Exe_path_s_res2.

println(Str) ->
    io:format("~s~n", [Str]).

main(Args) ->
    %% 9mlJlKg
    if length(Args) =/= 1 ->
        %% 7rOUXFo
        %% print program usage
        println("Usage: aoikwinwhich PROG"),
        println(""),
        println("#/ PROG can be either name or path"),
        println("aoikwinwhich notepad.exe"),
        println("aoikwinwhich C:\\Windows\\notepad.exe"),
        println(""),
        println("#/ PROG can be either absolute or relative"),
        println("aoikwinwhich C:\\Windows\\notepad.exe"),
        println("aoikwinwhich Windows\\notepad.exe"),
        println(""),
        println("#/ PROG can be either with or without extension"),
        println("aoikwinwhich notepad.exe"),
        println("aoikwinwhich notepad"),
        println("aoikwinwhich C:\\Windows\\notepad.exe"),
        println("aoikwinwhich C:\\Windows\\notepad"),

        %% 3nqHnP7
        noop
    ;true ->
        %% 9m5B08H
        %% get name or path of a program from cmd arg
        Prog = lists:nth(1, Args),

        %% 8ulvPXM
        %% find executables
        Path_s = find_executale(Prog),

        %% 5fWrcaF
        %% has found none, exit
        if length(Path_s) == 0 ->
            %% 3uswpx0
            noop
        ;true ->
            %% 9xPCWuS
            %% has found some, output
            Txt = string:join(Path_s, "\n"),

            println(Txt),

            %% 4s1yY1b
            noop
        end
    end.
