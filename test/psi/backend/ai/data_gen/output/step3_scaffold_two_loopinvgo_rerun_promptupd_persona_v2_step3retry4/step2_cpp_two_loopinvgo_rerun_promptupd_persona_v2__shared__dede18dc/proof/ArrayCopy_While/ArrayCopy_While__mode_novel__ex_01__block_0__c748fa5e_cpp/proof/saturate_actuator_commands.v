Require Import step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.prelude.proof.



Require step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.ArrayCopy_While.ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp.
#[local] Notation source := step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.src.ArrayCopy_While.ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp.module.
Require Import step2_cpp_two_loopinvgo_rerun_promptupd_persona_v2__shared__dede18dc.proof.ArrayCopy_While.ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp.spec.

(* wp hints *)
Export arrayLR_hints.
(* general big sep automation *)
Export hints.big_sep_hints.

Export OnlyProvableFEqual.

Export ptr_normalization_hints.

(* Export prim.AgressivePrimR. *)

Export normalize.only_provable_norm.

Section with_cpp.
    Context `{Σ : cpp_logic} `{MOD : source ⊧ σ}.
    Set Default Proof Using "MOD".

    Open Scope Z_scope.
    #[global,program] Instance CaseSplit_Zlt eql eqr (a b : Z) :
      TCMaybe (SolveArith (b ≤ a + 1)) eql ->
      TCMaybe (SolveArith (a ≤ b)) eqr ->
      CaseSplit (a <? b) :=
      { on_true := if eql then b = a + 1 else a < b ;
        on_false := if eqr then a = b else b <= a }.
    Next Obligation.
      intros ? ? ? ? L R. destruct (a <? b) eqn:?; constructor.
      + destruct L as [ [L] |]; destruct R as [[R]|]; lia.
      + destruct R as [[R]|]; lia.
      Qed.
    Next Obligation.
      intros ? ? ? ? L R.
      + destruct L as [ [L] |]; destruct R as [[R]|]; lia.
    Qed.

    (*@BEGIN:"proof"@*)
    Lemma saturate_actuator_commands_ok : verify[source] "saturate_actuator_commands(int *, int, int, int)".
    Proof.
      verify_spec; go.

      wp_for (fun ρ => Exists (i sat : Z) cmd_values_at_exit,
        i_addr         |-> intR 1$m i           **
        saturated_addr |-> intR 1$m sat         **
        cmd_addr       |-> ptrR<"int"> 1$m cmd **   (* ← stack slot only *)
        n_addr         |-> intR 1$m n        **
        min_cmd_addr   |-> intR 1$m min_cmd        **
        max_cmd_addr   |-> intR 1$m max_cmd           **
        cmd |-> arrayLR "int" 0 i (λ x : Z, intR 1$m x) (sliceZ 0 0 i cmd_values_at_exit) **
        cmd |-> arrayLR "int" i n (λ x : Z, intR 1$m x) (sliceZ 0 i n cmd_values_at_entry) **
        [| cmd_values_at_exit =
            (fun v =>
            if bool_decide (v < min_cmd) then min_cmd
            else if bool_decide (max_cmd < v) then max_cmd
            else v) <$> cmd_values_at_entry
        |] **
        (** TODO: *)
        (* [| sat = lengthZ (filter (λ v : Z, bool_decide (v < min_cmd ∨ max_cmd < v)) (sliceZ 0 0 i cmd_values_at_exit)) |] ** *)
        [| (0 <= i <= n)%Z |] **
        [| (0 <= sat <= i)%Z |])%Z; go.
      (* Unset SsrIdents.
      rename _t_ into i. *)
      wp_if; go.
      { wp_if => MinCmp; go.
        {
          rewrite list_lookupZ_fmap.
          (* iPureIntro. *)
          destruct (cmd_values_at_entry !! _) eqn:CmdLookup; simplify_eq/=.
          vc_split; work.
        }
        wp_if => MaxCmp; go.
        {
          rewrite list_lookupZ_fmap.
          (* iPureIntro. *)
          destruct (cmd_values_at_entry !! _) eqn:CmdLookup; simplify_eq/=.
          vc_split; work.
          vc_split; work.
        }
        {
          rewrite list_lookupZ_fmap.
          (* iPureIntro. *)
          destruct (cmd_values_at_entry !! _) eqn:CmdLookup; simplify_eq/=.
          vc_split; work.
          vc_split; work.
        }
      }
      go.
      wfocus [| _ |] "". {
        iPureIntro.
        rewrite sliceZ_self //. {
          rewrite map_fmap.
          apply fmap_ext_in => x Hin.
          repeat vc_split; lia.
        }
        rewrite lengthN_map. lia.
      }
      Import prim.AgressivePrimR.
      work.
      (* TODO last goal *)
      enough (_t_0 = length (List.filter (λ v : Z, (v <? min_cmd) || (max_cmd <? v)) cmd_values_at_entry)) by done.
      admit.
      (* TODO: add to invariant
      [| sat = lengthZ (filter (λ v : Z, bool_decide (v < min_cmd ∨ max_cmd < v)) (sliceZ 0 0 i cmd_values_at_exit)) |] ** *)
      all: fail.
    Admitted.
    (*@END@*)

    (*@BEGIN:"insert"@*)
(*
FAILED STEP4 PROOF ATTEMPT
lemma: saturate_actuator_commands_ok
task_id: proof/ArrayCopy_While/ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp/proof/saturate_actuator_commands.v#Lemma:saturate_actuator_commands_ok
status: Failure
failure_reason: ["Other", "Agent failed: The next request would exceed the request_limit of 30"]
final_tactic: backtracked(1)
tactic_trace:
  01. [OK] verify_spec; go
  02. [OK] wp_for (fun ρ => Exists i sat,
  i_addr |-> intR 1$m i **
  saturated_addr |-> intR 1$m sat **
  cmd_addr |-> ptrR<"int"> 1$m _v_3 **
  n_addr |-> intR 1$m _v_4 **
  min_cmd_addr |-> intR 1$m _v_5 **
  max_cmd_addr |-> intR 1$m v **
  [| (0 <= i <= _v_4)%Z |] **
  [| (0 <= sat <=...(truncated)

  03. [OK] iSplit; [iPureIntro; lia|gather_all].
  04. [OK] iSplit; [iPureIntro; lia|iFrame].
  05. [OK] destruct GUARDS.
  06. [OK] backtracked(1)
  07. [OK] backtracked(1)
  08. [OK] wp_for (fun ρ => Exists i sat,
  i_addr |-> intR 1$m i **
  saturated_addr |-> intR 1$m sat **
  cmd_addr |-> ptrR<"int"> 1$m _v_3 **
  n_addr |-> intR 1$m _v_4 **
  min_cmd_addr |-> intR 1$m _v_5 **
  max_cmd_addr |-> intR 1$m v **
  [| (0 <= i)%Z |] **
  [| (sat = i)%Z |])%Z; g...(truncated)
  09. [OK] wp_if.
  10. [OK] backtracked(2)
  11. [OK] wp_for (fun ρ => Exists i sat,
  i_addr |-> intR 1$m i **
  saturated_addr |-> intR 1$m sat **
  cmd_addr |-> ptrR<"int"> 1$m _v_3 **
  n_addr |-> intR 1$m _v_4 **
  min_cmd_addr |-> intR 1$m _v_5 **
  max_cmd_addr |-> intR 1$m v **
  [| (0 <= i)%Z |] **
  [| (0 <= sat <= i)%Z |]...(truncated)
  12. [OK] wp_if.
  13. [OK] go.
  14. [OK] iExists _, _.
  15. [OK] destruct GUARDS.
  16. [OK] iSplit.
  17. [OK] go.
  18. [OK] unfold ptrR in *.
  19. [OK] iPureIntro.
  20. [OK] iFrame.
  21. [OK] unfold valid_ptr.
  22. [FAIL] Qed.
      error: Qed failed - proof not complete
  23. [FAIL] backtracked(20)
      error: Backtrack failed
  24. [OK] Search valid_ptr.
  25. [OK] backtracked(1)
*)
(*@END@*)
End with_cpp.
