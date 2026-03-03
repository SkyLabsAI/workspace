Require Import step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.prelude.spec.


Require Export step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.ArrayCopy_While.ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp.pred.
Require step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.ArrayCopy_While.ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp.
#[local] Notation source := step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.ArrayCopy_While.ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp.module.

Section with_cpp.
    Context `{Σ : cpp_logic, source ⊧ σ}.

    (*@BEGIN:"saturate_actuator_commands(int *, int, int, int)"@*)
    cpp.spec "saturate_actuator_commands(int *, int, int, int)" as saturate_actuator_commands_spec with (
\with cmd
\with n
\with min_cmd
\with max_cmd
\with cmd_values_at_entry
\arg "cmd" (Vptr cmd)
\arg "n" (Vint n)
\arg "min_cmd" (Vint min_cmd)
\arg "max_cmd" (Vint max_cmd)
\require (valid<"int"> n)
\require (0 <= n)%Z
\require (valid<"int"> min_cmd)
\require (valid<"int"> max_cmd)
\require (min_cmd <= max_cmd)%Z
\pre cmd |-> arrayLR "int" 0 n (fun x => intR 1$m x) cmd_values_at_entry
\post{result}[Vint result]
  Exists cmd_values_at_exit,
    cmd |-> arrayLR "int" 0 n (fun x => intR 1$m x) cmd_values_at_exit **
    [| cmd_values_at_exit =
         List.map
           (fun v =>
              if Z.ltb v min_cmd then min_cmd
              else if Z.ltb max_cmd v then max_cmd
              else v)
           cmd_values_at_entry
    |] **
    [| (result =
         Z.of_nat
           (List.length
              (List.filter
                 (fun v => orb (Z.ltb v min_cmd) (Z.ltb max_cmd v))
                 cmd_values_at_entry)))%Z
    |]
).

    (*@END@*)

    (*@BEGIN:"insert"@*)(*@END@*)
End with_cpp.