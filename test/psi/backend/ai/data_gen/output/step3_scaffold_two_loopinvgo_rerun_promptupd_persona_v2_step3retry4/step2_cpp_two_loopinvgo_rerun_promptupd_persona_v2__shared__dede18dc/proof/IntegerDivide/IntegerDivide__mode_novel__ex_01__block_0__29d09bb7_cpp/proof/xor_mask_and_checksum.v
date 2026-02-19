Require Import step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.prelude.proof.



Require step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.IntegerDivide.IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp.
#[local] Notation source := step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.IntegerDivide.IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp.module.
Require Import step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.IntegerDivide.IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp.spec.

Section with_cpp.
    Context `{Σ : cpp_logic} `{MOD : source ⊧ σ}.
    Set Default Proof Using "MOD".

    (*@BEGIN:"proof"@*)
    Lemma xor_mask_and_checksum_ok : verify[source] "xor_mask_and_checksum(unsigned char *, int, unsigned char)".
    Proof. verify_spec; go. Admitted.
    (*@END@*)

    (*@BEGIN:"insert"@*)
(*
FAILED STEP4 PROOF ATTEMPT
lemma: xor_mask_and_checksum_ok
task_id: proof/IntegerDivide/IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp/proof/xor_mask_and_checksum.v#Lemma:xor_mask_and_checksum_ok
status: Failure
failure_reason: ["Other", "Agent finished but proof not closed"]
final_tactic: go.
tactic_trace:
  01. [OK] verify_spec; go
  02. [OK] wp_for (fun rho => Exists i sum, i_addr |-> intR 1$m i ** sum_addr |-> uintR 1$m sum ** [| (0 <= i <= _v_3)%Z |] ** [| valid<"unsigned int"> sum |])%Z; go.
  03. [OK] iSplit; [iPureIntro; lia|iFrame].
  04. [OK] backtracked(1)
  05. [OK] wp_for (fun rho => Exists i sum, i_addr |-> intR 1$m i ** sum_addr |-> uintR 1$m sum ** [| (i = 0)%Z |])%Z; go.
  06. [OK] wp_if; go.
  07. [OK] go.
  08. [OK] iExists (Vint 0%Z), (0%Qp).
*)
(*@END@*)
End with_cpp.
