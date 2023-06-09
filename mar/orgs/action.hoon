/-  orgs
=,  dejs:format
::
|_  =orgs-action:orgs
++  grab
  |%
  ++  noun  orgs-action:orgs
  ++  json
    |=  jon=^json
    ^-  orgs-action:orgs
    %-  orgs-action:orgs
    |^
    =/  procd  (process jon)
    ?.  ?=(%delete-org -.+.procd)  procd
    :-  -.procd
    [%delete-org -.+.+.procd +.+.+.procd ~]
    ::
    ++  process
      %-  ot
      :+  [%address (se %ux)]
        :-  %action
        %-  of
        :~  [%create parse-org]
          ::
            :-  %edit-org
            %-  ot
            :~  [%org-id (se %ux)]
                [%where pa]
                [%desc so:dejs-soft:format]
                [%controller (se-soft %ux)]
            ==
          ::
            :-  %add-sub-org
            %-  ot
            :~  [%org-id (se %ux)]
                [%where pa]
                [%org parse-org]
            ==
          ::
            :-  %delete-org
            %-  ot
            :~  [%org-id (se %ux)]
                [%where pa]
            ==
          ::
            :-  %add-member
            %-  ot
            :~  [%org-id (se %ux)]
                [%where pa]
                [%ship (se %p)]
            ==
          ::
            :-  %del-member
            %-  ot
            :~  [%org-id (se %ux)]
                [%where pa]
                [%ship (se %p)]
            ==
        ==
      ~
    ::
    ++  parse-org
      %-  ot
      :~  [%name so]
          [%parent-path pa]
          [%desc so:dejs-soft:format]
          [%controller (se %ux)]
          [%members (as (se %p))]
      ==
    ++  se-soft
      |=  aur=@tas
      |=  jon=^json
      ?>(?=([%s *] jon) (slaw aur p.jon))
    --
  --
::
++  grow
  |%
  ++  noun  orgs-action
  --
::
++  grad  %noun
::
--
