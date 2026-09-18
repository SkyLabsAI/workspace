let is_dune_cache_store_error_line : string -> bool = fun line ->
  let is_warning s =
    match String.index_opt s 'W' with None -> false | Some(i) ->
    try String.sub s i (String.length "Warning") = "Warning" with
    | Invalid_argument _ -> false
  in
  match String.split_on_char ' ' line with
  | warning :: "cache" :: "store" :: "error" :: _ -> is_warning warning
  | _ -> false

let bracketing_level : string -> int = fun line ->
  let f n c = match c with '(' -> n + 1 | ')' -> n - 1 | _ -> n in
  String.fold_left f 0 line

let skip_sexp ~buf ~level ic =
  let rec skip level =
    match level with 0 -> true | _ ->
    match In_channel.input_char ic with
    | None -> false
    | Some c ->
    Buffer.add_char buf c;
    match c with
    | '(' -> skip (level + 1)
    | ')' -> skip (level - 1)
    | _   -> skip level
  in
  skip level

let skip_to_colon ~buf ic =
  let rec skip () =
    match In_channel.input_char ic with
    | None -> false
    | Some c ->
    Buffer.add_char buf c;
    match c with
    | ':' -> true
    | _   -> skip ()
  in
  skip ()

let _ =
  let rec loop () =
    match In_channel.input_line stdin with None -> () | Some(line) ->
    match is_dune_cache_store_error_line line with
    | false -> Printf.printf "%s\n%!" line; loop ()
    | true  ->
    let buf = Buffer.create 73 in
    Buffer.add_string buf line;
    Buffer.add_char buf '\n';
    let level = bracketing_level line in
    match skip_sexp ~buf ~level stdin with
    | false -> Buffer.output_buffer stdout buf; Printf.printf "%!"
    | true  ->
    match skip_to_colon ~buf stdin with
    | false -> Buffer.output_buffer stdout buf; Printf.printf "%!"
    | true  ->
    match In_channel.input_line stdin with
    | None    -> ()
    | Some(_) -> loop ()
  in
  loop ()
