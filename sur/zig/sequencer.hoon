/-  *zig-engine
/+  smart=zig-sys-smart
|%
+$  ship-sig   [p=@ux q=ship r=life]
+$  sequencer  (pair address:smart ship)
::
+$  town  [=chain =hall]
::
+$  hall
  $:  town-id=@ux
      batch-num=@ud
      =sequencer
      mode=availability-method  ::  *always* %full-publish for now
      latest-diff-hash=@ux
      roots=(list @ux)
  ==
::
::  working state tracked here
::
+$  proposed-batch
  $:  num=@ud
      =processed-txs
      =chain
      diff-hash=@ux
      root=@ux
  ==
::
::  capitol: tracks sequencer and state roots / diffs for all towns
::
+$  capitol  (map @ux hall)
::
::  town state transition
::
+$  batch
  $:  town-id=id:smart
      num=@ud
      mode=availability-method  ::  *always* %full-publish for now
      state-diffs=(list state)
      diff-hash=@ux
      new-root=@ux
      new-state=chain
      peer-roots=(map id:smart @ux)  ::  roots for all other towns
      =sig:smart                     ::  sequencer signs new state root
  ==
::
+$  availability-method
  $%  [%full-publish ~]
      [%committee members=(map address:smart [ship (unit sig:smart)])]
  ==
::
+$  town-action
  $%  ::  administration
      $:  %init
          rollup-host=ship
          =address:smart
          private-key=@ux
          town-id=@ux
          starting-state=(unit chain)
          mode=availability-method
      ==
      ::  mostly deprecated
      [%set-block-height-api-key key=@t]
      [%del-block-height-api-key ~]
      ::  transactions
      [%receive =transaction:smart]
      [%run-pending ~]
  ==
::
+$  rollup-update
  $%  [%new-sequencer town=id:smart who=ship]
      $:  %new-peer-root
          =sequencer
          town=id:smart
          root=@ux
          batch-num=@ud
          timestamp=@da
      ==
  ==
::
+$  sidecar-action
  $%  [%trigger-batch deposits=(list tape)]
      [%batch-posted town-root=@ux block-at=@ud]
      [%batch-rejected town-root=@ux]
  ==
::
::  indexer must verify root is posted to rollup before verifying new state
::  pair of [transactions town] is batch from sur/indexer.hoon
+$  indexer-update
  $%  [%notify town=id:smart root=@ux]
      [%update root=@ux transactions=processed-txs town]
  ==
--
