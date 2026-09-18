  $ cat > log.txt <<EOF
  >         rocq bluerock/bhv/apps/vmm/proof/bm_dram.{glob,vo}
  >         rocq bluerock/NOVA/build-proof/proof/slab_hpp_spec/abs_pred.{glob,vo}
  >         rocq bluerock/bhv/apps/vmm/vml/devices/vuart/proof/seq_queue_spec.{glob,vo}
  >         rocq bluerock/bhv/zeta/lib/msc/proof/sys/user_signal_hpp_proof.{glob,vo}
  > Warning: cache store error [c15b25ec5f82c77c9696691cce5ed721]: ((in_cache
  > ((user_signal_hpp_proof.glob 8f014de7f22be00adb6a1e1b721b8fd5)
  > (user_signal_hpp_proof.vo a9e0a895fbe8b9cf5eb7033b601d9476))) (computed
  > ((user_signal_hpp_proof.glob d2c8b4198c8a588b3af5897fbee73f96)
  > (user_signal_hpp_proof.vo a9e0a895fbe8b9cf5eb7033b601d9476)))) after
  > executing action at bluerock/bhv/zeta/lib/msc/dune:4
  >         rocq bluerock/NOVA/build-proof/proof/cpu_hpp_spec/ghosts.{glob,vo}
  >         rocq bluerock/bhv/zeta/lib/porter/proof/server_hpp_spec.{glob,vo}
  >         rocq bluerock/bhv/zeta/lib/intrusive/proof/shared_pointer_hpp_proof.{glob,vo}
  >         rocq bluerock/bhv/apps/vswitch/proof/model/vswitch/lemmas.{glob,vo}
  >         rocq bluerock/bhv/lib/ddk/proof/interrupt_bhv_spec.{glob,vo}
  > Warning: cache store error [6173235dfde51952c3d0483038091ffc]: ((in_cache
  > ((interrupt_bhv_spec.glob fbcedbc4f4c0afce4af407f98d03bedf)
  > (interrupt_bhv_spec.vo 2ce9848741b1948d0eb8f0633860895f))) (computed
  > ((interrupt_bhv_spec.glob d1ed230db9dcdde1943598581cc45d04)
  > (interrupt_bhv_spec.vo 2ce9848741b1948d0eb8f0633860895f)))) after executing
  > action at bluerock/bhv/lib/ddk/dune:4
  >         rocq bluerock/NOVA/build-proof/proof/arch/mtd_arch_hpp_proof.{glob,vo}
  > Warning: cache store error [4efad17fd6dd76e05f1493758092436b]: ((in_cache
  > ((mtd_arch_hpp_proof.glob dcba66cc2ec6f290d3d748560fc1b717)
  > (mtd_arch_hpp_proof.vo d1c6fca29cf841ac94920e3607950fa9))) (computed
  > ((mtd_arch_hpp_proof.glob 64bf7baec56b710de8d1cc15923bec3f)
  > (mtd_arch_hpp_proof.vo d1c6fca29cf841ac94920e3607950fa9)))) after executing
  > action at bluerock/NOVA/build-proof/proof/dune:17
  >         rocq bluerock/bhv/zeta/lib/zeta/proof/semaphore_hpp_spec.{glob,vo}
  >         rocq bluerock/bhv/zeta/lib/zeta/proof/mutex_hpp_spec.{glob,vo}
  >         rocq bluerock/bhv/zeta/lib/zeta/proof/zeta_hpp_spec.{glob,vo}
  >         rocq bluerock/bhv/zeta/lib/zeta/proof/timer_hpp_spec.{glob,vo}
  > EOF

  $ filter-dune-output < log.txt
          rocq bluerock/bhv/apps/vmm/proof/bm_dram.{glob,vo}
          rocq bluerock/NOVA/build-proof/proof/slab_hpp_spec/abs_pred.{glob,vo}
          rocq bluerock/bhv/apps/vmm/vml/devices/vuart/proof/seq_queue_spec.{glob,vo}
          rocq bluerock/bhv/zeta/lib/msc/proof/sys/user_signal_hpp_proof.{glob,vo}
          rocq bluerock/NOVA/build-proof/proof/cpu_hpp_spec/ghosts.{glob,vo}
          rocq bluerock/bhv/zeta/lib/porter/proof/server_hpp_spec.{glob,vo}
          rocq bluerock/bhv/zeta/lib/intrusive/proof/shared_pointer_hpp_proof.{glob,vo}
          rocq bluerock/bhv/apps/vswitch/proof/model/vswitch/lemmas.{glob,vo}
          rocq bluerock/bhv/lib/ddk/proof/interrupt_bhv_spec.{glob,vo}
          rocq bluerock/NOVA/build-proof/proof/arch/mtd_arch_hpp_proof.{glob,vo}
          rocq bluerock/bhv/zeta/lib/zeta/proof/semaphore_hpp_spec.{glob,vo}
          rocq bluerock/bhv/zeta/lib/zeta/proof/mutex_hpp_spec.{glob,vo}
          rocq bluerock/bhv/zeta/lib/zeta/proof/zeta_hpp_spec.{glob,vo}
          rocq bluerock/bhv/zeta/lib/zeta/proof/timer_hpp_spec.{glob,vo}
