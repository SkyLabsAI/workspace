(subdir ArrayCopy_While
 (rule (target ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e_cpp.v) (alias ast)
  (deps (:input ArrayCopy_While__mode_novel__ex_01__block_0__c748fa5e.cpp))
  (action (chdir ../.. (run cpp2v -v %{input} -o %{target} --no-elaborate)))))
(subdir IntegerDivide
 (rule (target IntegerDivide__mode_novel__ex_01__block_0__29d09bb7_cpp.v) (alias ast)
  (deps (:input IntegerDivide__mode_novel__ex_01__block_0__29d09bb7.cpp))
  (action (chdir ../.. (run cpp2v -v %{input} -o %{target} --no-elaborate)))))
