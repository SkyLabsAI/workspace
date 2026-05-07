(** Command logged during a dune build. *)
type command = {
  command : string;
  (** Command that was run. *)
  output : string list;
  (** Lines of output from the command (including error message). *)
  status : int;
  (** Return code from the command (non-0 on failure). *)
}

(** [command_to_json command] turns [command] into its JSON representation. *)
val command_to_json : command -> Yojson.Safe.t

(** Exception raised by [read]. *)
exception Error of string

(** [read ic ~fname] extracts a list of run commands from the dune JSONL trace
    expected on channel [ic], corresponding to file name [fname]. In case of a
    file system error, the [Sys_error] exception is raised. If the channel has
    unexpected contents, an [Error] exception is raised. *)
val read : In_channel.t -> fname:string -> command list
