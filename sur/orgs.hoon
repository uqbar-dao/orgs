/-  sg=social-graph, uqbar=zig-uqbar,
    wallet=zig-wallet, indexer=zig-indexer
/+  smart=zig-sys-smart, eng=zig-sys-engine
/=  con  /con/lib/orgs
|%
::  set this to the deployed orgs contract
++  orgs-contract-id  ^-  id:smart
  0xb0f4.f607.41cf.4fac.3998.c923.cd1b.7132.f1b5.0d08.ee80.f00c.b23b.22b1.8b3c.c9c2
::
++  orgs-contract-town  ^-  id:smart
  0x0
::
+$  org-id  id:smart  ::  ID of an *item* containing org data
::
+$  orgs-receipt
  [=org-id =hash:smart =sequencer-receipt:uqbar]
::
+$  org
  $:  name=@t
      parent-path=path
      desc=(unit @t)
      controller=id:smart
      members=(set ship)
  ==
::
+$  orgs-action
  %+  pair  address:smart
  $%  [%create =org]
      [%edit-org org-id=id:smart where=path desc=(unit @t) controller=(unit id:smart)]
      [%add-sub-org org-id=id:smart where=path =org]
      [%delete-org org-id=id:smart where=path ~]
      [%add-member org-id=id:smart where=path =ship]
      [%del-member org-id=id:smart where=path =ship]
  ==
::
+$  orgs-update
  $%  [%members (set ship)]
      [%orgs (map org-id org:con)]
  ==
--
