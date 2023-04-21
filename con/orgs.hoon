::  orgs.hoon [UQ| DAO]
::
::  manage an organization on-chain
::
::  this contract is designed to emit updates to a %social-graph.
::  orgs.hoon allows users to create user-controlled organizations.
::  control of the org is delegated to an id, which can be a
::  multisig contract, some person's address, or something else
::  entirely... to make a DAO, need to build a separate voting contract
::  that acts as an org-controller.
::
::  this version of the contract is generic. anyone can deploy
::  a new org item and use this contract logic to manage it.
::
/+  *zig-sys-smart
/=  lib  /con/lib/orgs
|_  =context
++  write
  |=  act=action:lib
  ^-  (quip call diff)
  ?:  ?=(%create -.act)
    ::  org must be created by its controller
    ?>  =(controller.org.act id.caller.context)
    =/  =item
      :*  %&
          %:  hash-data
              this.context
              controller.org.act
              town.context
              name.org.act
          ==
          this.context
          controller.org.act
          town.context
          name.org.act
          %org
          org.act(parent-path ~)
      ==
    =-  `(result ~ [item ~] ~ -)
    (produce-org-events:lib id.p.item org.act)
  ::
  =/  org
    =+  (need (scry-state org-id.act))
    (husk org:lib - `this.context ~)
  ::  to manage, caller must control identified org
  ?>  =(id.caller.context controller.noun.org)
  =^  events  noun.org
    ?-    -.act
        %edit-org
      ::  empty tag defaults to the top level org
      =?  where.act  ?=(~ where.act)  /[name.noun.org]
      :-  ~
      %^  modify-org:lib
        noun.org  where.act
      |=  =org:lib
      %=    org
          desc
        ?~(desc.act desc.org desc.act)
          controller
        ?~(controller.act controller.org u.controller.act)
      ==
    ::
        %add-sub-org
      :-  (produce-org-events:lib id.org org.act)
      =.  parent-path.org.act
        (snoc parent-path.noun.org name.noun.org)
      %^  modify-org:lib
        noun.org  where.act
      |=  =org:lib
      =-  org(sub-orgs -)
      (~(put py sub-orgs.org) [name.org org]:act)
    ::
        %delete-org
      !!  ::  TODO
    ::
        %replace-members
      ::  empty tag defaults to the top level org
      =?  where.act  ?=(~ where.act)  /[name.noun.org]
      =/  =tag:lib  (weld parent-path.noun.org where.act)
      :-  %+  weld  (nuke-tag:lib tag)
          (make-tag:lib tag id.org new.act)
      %^  modify-org:lib
        noun.org  where.act
      |=(=org:lib org(members new.act))
    ::
        %add-member
      ::  empty tag defaults to the top level org
      =?  where.act  ?=(~ where.act)  /[name.noun.org]
      =/  =tag:lib  (weld parent-path.noun.org where.act)
      :-  (add-tag:lib tag id.org ship.act)
      %^  modify-org:lib
        noun.org  where.act
      |=  =org:lib
      org(members (~(put pn members.org) ship.act))
    ::
        %del-member
      ::  empty tag defaults to the top level org
      =?  where.act  ?=(~ where.act)  /[name.noun.org]
      =/  =tag:lib  (weld parent-path.noun.org where.act)
      :-  (del-tag:lib tag id.org ship.act)
      %^  modify-org:lib
        noun.org  where.act
      |=  =org:lib
      org(members (~(del pn members.org) ship.act))
    ==
  `(result [&+org ~] ~ ~ events)
::
++  read
  |=  =pith
  ~  ::  TODO
--
