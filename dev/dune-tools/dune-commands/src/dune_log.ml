type command = {
  command : string;
  output : string list;
  status : int;
}
[@@deriving yojson]

let command_to_json = command_to_yojson

exception Error of string

let error : string -> 'a = fun s ->
  raise (Error(s))

let read : In_channel.t -> fname:string -> command list = fun ic ~fname ->
  let lines = In_channel.input_lines ic in
  let parse i line =
    let lnum = i + 1 in
    let error s =
      error (Printf.sprintf "File %s, line %i: %s" fname lnum s)
    in
    let json =
      try Yojson.Safe.from_string ~fname ~lnum line with
      | Yojson.Json_error(s) -> error ("JSON parse failure.\n" ^ s)
    in
    let assoc =
      match json with
      | `Assoc(fields) -> fields
      | _              -> error "unexpected JSON value (not an object)"
    in
    let get field =
      try List.assoc field assoc with Not_found ->
        error ("no field \"" ^ field ^ "\"")
    in
    if get "cat" <> `String("process") then None else
    if get "name" <> `String("finish") then None else
    let args =
      match get "args" with
      | `Assoc(fields) -> fields
      | _              -> error "ill-typed \"args\" field"
    in
    let get field =
      try List.assoc field args with Not_found ->
        error ("no field \"" ^ field ^ "\"")
    in
    let status =
      match get "exit" with
      | `Int(i) -> i
      | _       -> error "ill-typed \"exit\" field"
    in
    let output =
      let lines s =
        let parts = String.split_on_char '\n' s in
        match List.rev parts with
        | "" :: parts -> List.rev parts
        | _           -> parts
      in
      let get s =
        match List.assoc_opt s args with
        | None             -> []
        | Some(`String(s)) -> lines s
        | _                -> error ("ill-typed \"" ^ s ^ "\" field")
      in
      get "stdout" @ get "stderr"
    in
    let command =
      let prog =
        match get "prog" with
        | `String(p) -> Filename.basename p
        | _          -> error ("ill-typed \"prog\" field")
      in
      let dir =
        match List.assoc_opt "dir" args with
        | None             -> None
        | Some(`String(s)) -> Some(s)
        | _                -> error ("ill-typed \"dir\" field")
      in
      let args =
        match List.assoc_opt "process_args" args with
        | None              -> []
        | Some(`List(args)) -> args
        | _                 -> error ("ill-typed \"process_args\" field")
      in
      let args =
        let get_string json =
          match json with
          | `String(s) -> s
          | _          -> error "expected a string"
        in
        List.map get_string args
      in
      let command = String.concat " " (prog :: args) in
      match dir with
      | None    -> command
      | Some(d) -> Printf.sprintf "(cd %s && %s)" d command
    in
    Some({command; output; status})
  in
  List.filter_map Fun.id (List.mapi parse lines)
