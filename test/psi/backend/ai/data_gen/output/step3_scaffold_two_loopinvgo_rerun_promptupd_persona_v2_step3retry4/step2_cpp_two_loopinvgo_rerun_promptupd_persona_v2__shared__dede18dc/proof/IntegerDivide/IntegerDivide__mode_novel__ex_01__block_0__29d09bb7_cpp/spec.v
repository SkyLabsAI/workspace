Require Import step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.prelude.spec.


Require Export step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.IntegerDivide.IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp.pred.
Require step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.IntegerDivide.IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp.
#[local] Notation source := step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.IntegerDivide.IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp.module.

Section with_cpp.
    Context `{Σ : cpp_logic, source ⊧ σ}.

    (*@BEGIN:"xor_mask_and_checksum(unsigned char *, int, unsigned char)"@*)
    cpp.spec "xor_mask_and_checksum(unsigned char *, int, unsigned char)" as xor_mask_and_checksum_spec with (
\with buf
\with n
\with key
\with buf_values_at_entry
\arg "buf" (Vptr buf)
\arg "n" (Vint n)
\arg "key" (Vint key)
\require (valid<"int"> n)
\require (0 <= n)%Z
\require (valid<"uchar"> key)
\pre buf |-> arrayLR "uchar" 0 n (fun x => ucharR 1$m x) buf_values_at_entry
\post{result}[Vint result]
  Exists buf_values_at_exit,
    buf |-> arrayLR "uchar" 0 n (fun x => ucharR 1$m x) buf_values_at_exit **
    [| buf_values_at_exit = List.map (fun x => Z.lxor x key) buf_values_at_entry |] **
    [| (result = Z.modulo (List.fold_right Z.add 0%Z buf_values_at_exit) 256%Z)%Z |]
).

    (*@END@*)

    (*@BEGIN:"insert"@*)(*@END@*)
End with_cpp.