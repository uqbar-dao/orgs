/-  *zig-zink
/+  *zink-pedersen, *zink-json, smart=zig-sys-smart
=>  |%
    +$  good      (unit *)
    +$  fail      (list [@ta *])
    +$  body      (each good fail)
    +$  cache     (map * phash)
    +$  appendix  [cax=cache jets=jetmap hit=hints gas=@]
    +$  book      (pair body appendix)
    --
|%
++  zebra                                                 ::  bounded zk +mule
  |=  [gas=@ud cax=cache =jetmap scry=chain-state-scry [s=* f=*] hints-on=?]
  ^-  book
  ~>  %bout
  %.  [s f scry hints-on]
  %*  .  zink
    app  [cax jetmap ~ gas]
  ==
::
::  ++  hash
::    |=  [n=* cax=(map * phash)]
::    ^-  phash
::    ?@  n
::      ?:  (lte n 12)
::        =/  ch  (~(get by cax) n)
::        ?^  ch  u.ch
::        (hash:pedersen n 0)
::      (hash:pedersen n 0)
::    ?^  ch=(~(get by cax) n)
::      u.ch
::    =/  hh  $(n -.n)
::    =/  ht  $(n +.n)
::    (hash:pedersen hh ht)
::
::  ++  create-hints
::    |=  [n=^ h=hints cax=cache]
::    ^-  json
::    =/  hs  (hash -.n cax)
::    =/  hf  (hash +.n cax)
::    %-  pairs:enjs:format
::    :~  hints+(hints:enjs h)
::        subject+s+(num:enjs hs)
::        formula+s+(num:enjs hf)
::    ==
::
++  zink
  =|  appendix
  =*  app  -
  =|  trace=fail
  |=  [s=* f=* scry=chain-state-scry hints-on=?]
  ^-  book
  |^
  |-
  ?+    f
    [%|^trace app]
  ::
      [^ *]
    =^  hed=body  app
      $(f -.f)
    ?:  ?=(%| -.hed)  [%|^trace app]
    ?~  p.hed  [%&^~ app]
    =^  tal=body  app
      $(f +.f)
    ?:  ?=(%| -.tal)  [%|^trace app]
    ?~  p.tal  [%&^~ app]
    =^  hhed=(unit phash)  app  (hash -.f)
    ?~  hhed  [%&^~ app]
    =^  htal=(unit phash)  app  (hash +.f)
    ?~  htal  [%&^~ app]
    :-  [%& ~ u.p.hed^u.p.tal]
    app(hit [%cons u.hhed u.htal]^hit)
  ::
      [%0 axis=@]
    =^  part  gas
      (frag axis.f s gas)
    ?~  part  [%&^~ app]
    ?~  u.part  [%|^trace app]
    =^  hpart=(unit phash)         app  (hash u.u.part)
    ?~  hpart  [%&^~ app]
    =^  hsibs=(unit (list phash))  app  (merk-sibs s axis.f)
    ?~  hsibs  [%&^~ app]
    :-  [%& ~ u.u.part]
    app(hit [%0 axis.f u.hpart u.hsibs]^hit)
  ::
      [%1 const=*]
    =^  hres=(unit phash)  app  (hash const.f)
    ?~  hres  [%&^~ app]
    :-  [%& ~ const.f]
    app(hit [%1 u.hres]^hit)
  ::
      [%2 sub=* for=*]
    =^  hsub=(unit phash)  app  (hash sub.f)
    ?~  hsub  [%&^~ app]
    =^  hfor=(unit phash)  app  (hash for.f)
    ?~  hfor  [%&^~ app]
    =^  subject=body  app
      $(f sub.f)
    ?:  ?=(%| -.subject)  [%|^trace app]
    ?~  p.subject  [%&^~ app]
    =^  formula=body  app
      $(f for.f)
    ?:  ?=(%| -.formula)  [%|^trace app]
    ?~  p.formula  [%&^~ app]
    %_  $
      s    u.p.subject
      f    u.p.formula
      hit  [%2 u.hsub u.hfor]^hit
    ==
  ::
      [%3 arg=*]
    =^  argument=body  app
      $(f arg.f)
    ?:  ?=(%| -.argument)  [%|^trace app]
    ?~  p.argument  [%&^~ app]
    =^  harg=(unit phash)  app  (hash arg.f)
    ?~  harg  [%&^~ app]
    ?@  u.p.argument
      :-  [%& ~ %.n]
      app(hit [%3 u.harg %atom u.p.argument]^hit)
    =^  hhash=(unit phash)  app  (hash -.u.p.argument)
    ?~  hhash  [%&^~ app]
    =^  thash=(unit phash)  app  (hash +.u.p.argument)
    ?~  thash  [%&^~ app]
    :-  [%& ~ %.y]
    app(hit [%3 u.harg %cell u.hhash u.thash]^hit)
  ::
      [%4 arg=*]
    =^  argument=body  app
      $(f arg.f)
    ?:  ?=(%| -.argument)  [%|^trace app]
    =^  harg=(unit phash)  app  (hash arg.f)
    ?~  harg  [%&^~ app]
    ?~  p.argument  [%&^~ app]
    ?^  u.p.argument  [%|^trace app]
    :-  [%& ~ .+(u.p.argument)]
    app(hit [%4 u.harg u.p.argument]^hit)
  ::
      [%5 a=* b=*]
    =^  ha=(unit phash)  app  (hash a.f)
    ?~  ha  [%&^~ app]
    =^  hb=(unit phash)  app  (hash b.f)
    ?~  hb  [%&^~ app]
    =^  a=body  app
      $(f a.f)
    ?:  ?=(%| -.a)  [%|^trace app]
    ?~  p.a  [%&^~ app]
    =^  b=body  app
      $(f b.f)
    ?:  ?=(%| -.b)  [%|^trace app]
    ?~  p.b  [%&^~ app]
    :-  [%& ~ =(u.p.a u.p.b)]
    app(hit [%5 u.ha u.hb]^hit)
  ::
      [%6 test=* yes=* no=*]
    =^  htest=(unit phash)  app  (hash test.f)
    ?~  htest  [%&^~ app]
    =^  hyes=(unit phash)   app  (hash yes.f)
    ?~  hyes  [%&^~ app]
    =^  hno=(unit phash)    app  (hash no.f)
    ?~  hno  [%&^~ app]
    =^  result=body  app
      $(f test.f)
    ?:  ?=(%| -.result)  [%|^trace app]
    ?~  p.result  [%&^~ app]
    =.  hit  [%6 u.htest u.hyes u.hno]^hit
    ?+  u.p.result  [%|^trace app]
      %&  $(f yes.f)
      %|  $(f no.f)
    ==
  ::
      [%7 subj=* next=*]
    =^  hsubj=(unit phash)  app  (hash subj.f)
    ?~  hsubj  [%&^~ app]
    =^  hnext=(unit phash)  app  (hash next.f)
    ?~  hnext  [%&^~ app]
    =^  subject=body  app
      $(f subj.f)
    ?:  ?=(%| -.subject)  [%|^trace app]
    ?~  p.subject  [%&^~ app]
    %_  $
      s    u.p.subject
      f    next.f
      hit  [%7 u.hsubj u.hnext]^hit
    ==
  ::
      [%8 head=* next=*]
    =^  hhead=(unit phash)  app  (hash head.f)
    ?~  hhead  [%&^~ app]
    =^  hnext=(unit phash)  app  (hash next.f)
    ?~  hnext  [%&^~ app]
    =^  head=body  app
      $(f head.f)
    ?:  ?=(%| -.head)  [%|^trace app]
    ?~  p.head  [%&^~ app]
    %_  $
      s    [u.p.head s]
      f    next.f
      hit  [%8 u.hhead u.hnext]^hit
    ==
  ::
      [%9 axis=@ core=*]
    =^  hcore=(unit phash)  app  (hash core.f)
    ?~  hcore  [%&^~ app]
    =^  core=body  app
      $(f core.f)
    ?:  ?=(%| -.core)  [%|^trace app]
    ?~  p.core  [%&^~ app]
    =^  arm  gas
      (frag axis.f u.p.core gas)
    ?~  arm  [%&^~ app]
    ?~  u.arm  [%|^trace app]
    =^  harm=(unit phash)  app  (hash u.u.arm)
    ?~  harm  [%&^~ app]
    =^  hsibs=(unit (list phash))  app  (merk-sibs u.p.core axis.f)
    ?~  hsibs  [%&^~ app]
    %_  $
      s    u.p.core
      f    u.u.arm
      hit  [%9 axis.f u.hcore u.harm u.hsibs]^hit
    ==
  ::
      [%10 [axis=@ value=*] target=*]
    =^  hval=(unit phash)  app  (hash value.f)
    ?~  hval  [%&^~ app]
    =^  htar=(unit phash)  app  (hash target.f)
    ?~  htar  [%&^~ app]
    ?:  =(0 axis.f)  [%|^trace app]
    =^  target=body  app
      $(f target.f)
    ?:  ?=(%| -.target)  [%|^trace app]
    ?~  p.target  [%&^~ app]
    =^  value=body  app
      $(f value.f)
    ?:  ?=(%| -.value)  [%|^trace app]
    ?~  p.value  [%&^~ app]
    =^  mutant=(unit (unit *))  gas
      (edit axis.f u.p.target u.p.value gas)
    ?~  mutant  [%&^~ app]
    ?~  u.mutant  [%|^trace app]
    =^  oldleaf  gas
      (frag axis.f u.p.target gas)
    ?~  oldleaf  [%&^~ app]
    ?~  u.oldleaf  [%|^trace app]
    =^  holdleaf=(unit phash)  app  (hash u.u.oldleaf)
    ?~  holdleaf  [%&^~ app]
    =^  hsibs=(unit (list phash))  app  (merk-sibs u.p.target axis.f)
    ?~  hsibs  [%&^~ app]
    :-  [%& ~ u.u.mutant]
    app(hit [%10 axis.f u.hval u.htar u.holdleaf u.hsibs]^hit)
  ::
       [%11 tag=@ next=*]
    ::  ~&  >  `@tas`tag.f
    =^  next=body  app
      $(f next.f)
    :_  app
    ?:  ?=(%| -.next)  %|^trace
    ?~  p.next  %&^~
    :+  %&  ~
    .*  s
    [11 tag.f 1 u.p.next]
  ::
      [%11 [tag=@ clue=*] next=*]
    ::  look for jet with this tag and compute sample
    =^  sam=body  app
      $(f clue.f)
    ?:  ?=(%| -.sam)  [%|^trace app]
    ?~  p.sam  [%&^~ app]
    ::  if jet exists for this tag, and sample is good,
    ::  replace execution with jet
    =^  jax=body  app
      ?:  ?=(?(%hunk %hand %lose %mean %spot) tag.f)
        [%&^~ app]
      (jet tag.f u.p.sam)
    ?:  ?=(%| -.jax)  [%|^trace app]
    ?^  p.jax  [%& p.jax]^app
    ::  jet not found, proceed with normal computation
    =^  clue=body  app
      $(f clue.f)
    ?:  ?=(%| -.clue)  [%|^trace app]
    ?~  p.clue  [%&^~ app]
    =^  next=body  app
      =?    trace
          ?=(?(%hunk %hand %lose %mean %spot) tag.f)
        [[tag.f u.p.clue] trace]
      $(f next.f)
    :_  app
    ?:  ?=(%| -.next)  %|^trace
    ?~  p.next  %&^~
    :+  %&  ~
    .*  s
    [11 [tag.f 1 u.p.clue] 1 u.p.next]
  ::
      [%12 ref=* path=*]
    ::  TODO hash ref, path and grain id parsed as last item in path
    ::       hash product and path through granary merkle tree
    ::       (similar process in nock 0)
    =^  ref=body  app
      $(f ref.f)
    ?:  ?=(%| -.ref)     [%|^trace app]
    ?~  p.ref            [%&^~ app]
    =^  path=body  app
      $(f path.f)
    ?:  ?=(%| -.path)    [%|^trace app]
    ?~  p.path           [%&^~ app]
    =/  result  (scry gas p.ref p.path)
    ?~  product.result
      [%&^~^~ app(gas gas.result)]
    [%&^[~ product.result] app(gas gas.result)]
  ==
  ::
  ++  jet
    |=  [tag=@ sam=*]
    ^-  book
    ?:  ?=(%slog tag)
      ::  print trace printfs?
      [%&^~ app]
    ?:  ?=(%mean tag)
      ::  this is a crash..
      [%|^trace app]
    ?~  cost=(~(get by jets.app) tag)
      ::  ~&  [%missing-jet `@tas`tag]
      [%&^~ app]
    ::  ~&  [%running-jet `@tas`tag]
    ?:  (lth gas u.cost)  [%&^~ app]
    :-  (run-jet tag sam `@ud`u.cost)
    app(gas (sub gas u.cost))
  ::
  ++  run-jet
    |=  [tag=@ sam=* cost=@ud]
    ^-  body
    ::  TODO: probably unsustainable to need to include assertions to
    ::  make all jets crash safe.
    ?+    tag  %|^trace
    ::                                                                       ::
    ::  math                                                                 ::
    ::                                                                       ::
        %add
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (add sam))
    ::
        %dec
      ?.  ?=(@ sam)  %|^trace
      %&^(some (dec sam))
    ::
        %div
      ?.  ?=([@ @] sam)  %|^trace
      ?.  (gth +.sam 0)  %|^trace
      %&^(some (div sam))
    ::
        %dvr
      ?.  ?=([@ @] sam)  %|^trace
      ?.  (gth +.sam 0)  %|^trace
      %&^(some (dvr sam))
    ::
        %gte
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (gte sam))
    ::
        %gth
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (gth sam))
    ::
        %lte
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (lte sam))
    ::
        %lth
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (lth sam))
    ::
        %max
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (max sam))
    ::
        %min
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (min sam))
    ::
        %mod
      ?.  ?=([@ @] sam)  %|^trace
      ?.  (gth +.sam 0)  %|^trace
      %&^(some (mod sam))
    ::
        %mul
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (mul sam))
    ::
        %sub
      ?.  ?=([@ @] sam)      %|^trace
      ?.  (gte -.sam +.sam)  %|^trace
      %&^(some (sub sam))
    ::                                                                       ::
    ::  bits                                                                 ::
    ::                                                                       ::
        %bex
      ?.  ?=(bloq sam)  %|^trace
      %&^(some (bex sam))
    ::
        %can
      ::  TODO validate
      %&^(some (slum can sam))
    ::
        %cat
      ?.  ?=([bloq @ @] sam)  %|^trace
      %&^(some (cat sam))
    ::
        %cut
      ?.  ?=([bloq [step step] @] sam)  %|^trace
      %&^(some (cut sam))
    ::
        %end
      ?.  ?=([bite @] sam)  %|^trace
      %&^(some (end sam))
    ::
        %fil
      ?.  ?=([bloq step @] sam)  %|^trace
      %&^(some (fil sam))
    ::
        %lsh
      ?.  ?=([bloq @] sam)  %|^trace
      %&^(some (lsh sam))
    ::
        %met
      ?.  ?=([bloq @] sam)  %|^trace
      %&^(some (met sam))
    ::
        %rap
      ::  TODO validate
      %&^(some (slum rap sam))
    ::
        %rep
      ::  TODO validate
      %&^(some (slum rep sam))
    ::
        %rev
      ?.  ?=([bloq @ud @] sam)  %|^trace
      %&^(some (rev sam))
    ::
        %rip
      ?.  ?=([bite @] sam)  %|^trace
      %&^(some (rip sam))
    ::
        %rsh
      ?.  ?=([bite @] sam)  %|^trace
      %&^(some (rsh sam))
    ::
        %run
      ::  TODO validate
      %&^(some (slum run sam))
    ::
        %rut
      ::  TODO validate
      %&^(some (slum rut sam))
    ::
        %sew
      ?.  ?=([bloq [step step @] @] sam)  %|^trace
      %&^(some (sew sam))
    ::
        %swp
      ?.  ?=([bloq @] sam)  %|^trace
      %&^(some (swp sam))
    ::
        %xeb
      ?.  ?=(@ sam)  %|^trace
      %&^(some (xeb sam))
    ::
    ::                                                                       ::
    ::  list                                                                 ::
    ::                                                                       ::
      ::  this one actually fails, so really need to find a better way.
      ::    %turn
      ::  ::  TODO: determine how best to validate complex jet inputs
      ::  ::  this will crash if the input is bad.
      ::  %&^(some (slum turn sam))
    ::                                                                       ::
    ::  sha                                                                  ::
    ::                                                                       ::
        %sham
      %&^(some (sham sam))
    ::
        %shax
      ?.  ?=(@ sam)  %|^trace
      %&^(some (shax sam))
    ::
        %shay
      ?.  ?=([@u @] sam)  %|^trace
      %&^(some (shay sam))
    ::                                                                       ::
    ::  merklization                                                         ::
    ::                                                                       ::
    ::      %shag
    ::    %&^(some (shag:smart sam))
    ::  ::
    ::      %sore
    ::    ?.  ?=([* *] sam)  %|^trace
    ::    %&^(some (sore:smart sam))
    ::  ::
    ::      %sure
    ::    ?.  ?=([* *] sam)  %|^trace
    ::    %&^(some (sure:smart sam))
    ::
        %rlp-encode
      %&^(some (encode:rlp:smart sam))
    ::                                                                       ::
    ::  etc                                                                  ::
    ::                                                                       ::
        %need
      ?.  ?=((unit) sam)  %|^trace
      ?:  ?=(~ sam)       %|^trace
      %&^(some (need sam))
    ::
        %scot
      ?.  ?=([@ta @] sam)  %|^trace
      %&^(some (scot sam))
    ::
        %pedersen-hash
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (hash:pedersen sam))
    ::                                                                       ::
    ::  crypto                                                               ::
    ::                                                                       ::
        %k224
      ?.  ?=([@ud @] sam)  %|^trace
      %&^(some (keccak-224:keccak:crypto sam))
    ::
        %k256
      ?.  ?=([@ud @] sam)  %|^trace
      %&^(some (keccak-256:keccak:crypto sam))
    ::
        %k384
      ?.  ?=([@ud @] sam)  %|^trace
      %&^(some (keccak-384:keccak:crypto sam))
    ::
        %k512
      ?.  ?=([@ud @] sam)  %|^trace
      %&^(some (keccak-512:keccak:crypto sam))
    ::
        %make
      ?.  ?=([@uvI @] sam)  %|^trace
      %&^(some (make-k:secp256k1:secp:crypto sam))
    ::
        %sign
      ?.  ?=([@uvI @] sam)  %|^trace
      %&^(some (ecdsa-raw-sign:secp256k1:secp:crypto sam))
    ::
        %reco
      ?.  ?=([@ [@ @ @]] sam)  %|^trace
      %&^(some (ecdsa-raw-recover:secp256k1:secp:crypto sam))
    ==
  ::
  ++  frag
    |=  [axis=@ noun=* gas=@ud]
    ^-  [(unit (unit)) @ud]
    ?:  =(0 axis)  [`~ gas]
    |-  ^-  [(unit (unit)) @ud]
    ?:  =(0 gas)  [~ gas]
    ?:  =(1 axis)  [``noun (dec gas)]
    ?@  noun  [`~ (dec gas)]
    =/  pick  (cap axis)
    %=  $
      axis  (mas axis)
      noun  ?-(pick %2 -.noun, %3 +.noun)
      gas   (dec gas)
    ==
  ::
  ++  edit
    |=  [axis=@ target=* value=* gas=@ud]
    ^-  [(unit (unit)) @ud]
    ?:  =(1 axis)  [``value gas]
    ?@  target  [`~ gas]
    ?:  =(0 gas)  [~ gas]
    =/  pick  (cap axis)
    =^  mutant  gas
      %=  $
        axis    (mas axis)
        target  ?-(pick %2 -.target, %3 +.target)
        gas     (dec gas)
      ==
    ?~  mutant  [~ gas]
    ?~  u.mutant  [`~ gas]
    ?-  pick
      %2  [``[u.u.mutant +.target] gas]
      %3  [``[-.target u.u.mutant] gas]
    ==
  ::
  ++  hash
    |=  n=*
    ^-  [(unit phash) appendix]
    ::  test mode disables hashing, so it won't generate valid hints.
    ::  however, computation is *much* faster since hashing is the
    ::  most expensive aspect of the process.
    ?.  hints-on  [`0x1 app]
    =/  mh  (~(get by cax) n)
    ?^  mh
      ?:  =(gas 0)  [~ app]
      [mh app(gas (dec gas))]
    ?@  n
      ?:  =(gas 0)  [~ app]
      =/  h  (hash:pedersen n 0)
      :-  `h
      app(cax (~(put by cax) n h), gas (dec gas))
    =^  hh=(unit phash)  app  $(n -.n)
    ?~  hh  [~ app]
    =^  ht=(unit phash)  app  $(n +.n)
    ?~  ht  [~ app]
    =/  h  (hash:pedersen u.hh u.ht)
    ?:  =(gas 0)  [~ app]
    :-  `h
    app(cax (~(put by cax) n h), gas (dec gas))
  ::
  ++  merk-sibs
    |=  [s=* axis=@]
    =|  path=(list phash)
    |-  ^-  [(unit (list phash)) appendix]
    ?:  =(1 axis)
      [`path app]
    ?~  axis  !!
    ?@  s  !!
    =/  pick  (cap axis)
    =^  sibling=(unit phash)  app
      %-  hash
      ?-(pick %2 +.s, %3 -.s)
    ?~  sibling  [~ app]
    =/  child  ?-(pick %2 -.s, %3 +.s)
    %=  $
      s     child
      axis  (mas axis)
      path  [u.sibling path]
    ==
  --
--
