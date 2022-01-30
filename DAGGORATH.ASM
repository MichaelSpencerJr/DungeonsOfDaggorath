;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;       DUNGEONS     OF     DAGGORATH
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;         Copyright (c) 1983 - Unified Technologies, Inc.
;                       12479 Walsh Avenue
;                    Los Angeles, Calif. 90066
;
;                       Tel. (213) 822-9989
;
;
;
;                             WARNING !!!
;
;
;    No  part of this work - documents,  schematic  diagrams,
;    drawings,  printed circuit board artwork, program source
;    listings  or  object  code,   may be reproduced  by  any
;    mechanical,  photographic,  or electronic process, or in
;    the  form  of a phonographic recording,  nor may  it  be
;    stored in a retrieval system,  transmitted, or otherwise
;    copied  for public or private  use,  without  permission
;    from Unified Technologies, Inc.
;
;    This  software [and manual] are both protected  by  U.S.
;    Copyright  Law (Title 17 United States  Code).  Unautho-
;    rized  reproduction and/or sales may result in imprison-
;    ment of up to 1 year and fines of up to $10,000 (17  USC
;    506).  Copyright infringers may also be subject to civil
;    liability.
;
;    All graphic designs and displays,  technical manuals and
;    accompanying  schematic  diagrams are protected  by  the
;    U.S. Copyright Act of 1976.
;
;    This  Act provides for increased penalties for violating
;    federal  copyright laws.  Courts CAN IMPOUND  infringing
;    articles  while legal action is pending.  If  infringers
;    are convicted,  courts can ORDER DESTRUCTION of the  in-
;    fringing articles.
;
;    In  addition,  the Act provides for payment of statutory
;    damages  of up to $50,000 in certain  cases.  Infringers
;    may also have to pay costs and attorney's fees, fines of
;    up  to $25,000,  and face an imprisonment of up  to  one
;    year.
;
;    Unified Technologies, Inc. will aggressively enforce its
;    copyrights against any infringers. WE WILL USE ALL LEGAL
;    MEANS to immediately halt the manufacture, distribution,
;    illegal  use  or  operation of a copy of a  hardware  or
;    software  system made by us.  Anyone who purchases  such
;    copies risks forfeiting such a copy.
;
;
;  Acknowledgements:
;
;       This program would not have been possible without the
;  help of Doug, Phil, April, and Jim.  After almost two years, it may
;  finally get out in cartridge form...
;
;                       Thank you, thank you, thank you!
;
;                               Keith S. Kiyohara
;                               July 20, 1983
;
;; 2022-01-22 MJS These appear to be not needed - commented
;;
;;
;;   Operator synonyms
;;
;FCB     OPSYN   DB
;FDB     OPSYN   DW
;FCC     OPSYN   DB
;RMB     OPSYN   DS
;; END 2022-01-22
;
;    include all game files
;
;
        ;lwasm compatibility
        pragma  nodollarlocal,6809

        ;Assembler listing output generally contains commented macro invocations
        ;followed by the expanded form of the called macro, which is then assembled.
        ;Where possible I tried to recreate original source code by un-expanding these
        ;macro invocations.  Some macros had missing definitions, which were recreated.
        ;Since these recreated macros were not original, I am moving them to a separate file.
        include missing-macros.asm

        INCLUDE CD.ASM           ;Common Definition File
        INCLUDE ONCE.ASM         ;Once only Initialization
        INCLUDE COMMON.ASM       ;Common Operating System Routines
        INCLUDE COMSWI.ASM       ;Common SWI Dispatch
        INCLUDE VCTLST.ASM       ;Display list Processor
        INCLUDE TXTSER.ASM       ;Text Service Routine
        INCLUDE EXPAND.ASM       ;Byte Expansion Routine
        INCLUDE RANDOM.ASM       ;Random Number Generator
        INCLUDE CLEAR.ASM        ;Display Clearing Routine
        INCLUDE HUPDAT.ASM       ;Heart Update Routine
        INCLUDE STATUS.ASM       ;Status Line Update Routine
        INCLUDE PUPDAT.ASM       ;Update the Screen
        INCLUDE MISC.ASM         ;Misc Service Routines
        INCLUDE OBIRTH.ASM       ;Object Birth Routine
        INCLUDE PLOOK.ASM        ;Look Command
        INCLUDE NEWLVL.ASM       ;Create a New Dungeon Level
        INCLUDE SOUNDS.ASM       ;Sound Generator
        INCLUDE COMTXT.ASM       ;Text Display Service Routines
        INCLUDE VECTOR.ASM       ;Vector Generator
        INCLUDE PARSER.ASM       ;Line Parsing Routines
        INCLUDE DGNGEN.ASM       ;Dungeon Maze Generator
        INCLUDE MAPPER.ASM       ;Map Display Generator
        INCLUDE VIEWER.ASM       ;Dungeon Viewer
        INCLUDE COMCRE.ASM       ;Creature Movement Routines
        INCLUDE CRETUR.ASM       ;Creature Movement Routines
        INCLUDE COMPLR.ASM       ;Common Player Routines
        INCLUDE HUMAN.ASM        ;Human Interface Module
        INCLUDE PATTK.ASM        ;Attack Command
        INCLUDE PCLIMB.ASM       ;Climb Command
        INCLUDE PEXAM.ASM        ;Examine Command
        INCLUDE PGET.ASM         ;Get Command
        INCLUDE PINCAN.ASM       ;Incant Command
        INCLUDE PREVEA.ASM       ;Reveal Command
        INCLUDE PTURN.ASM        ;Turn Command
        INCLUDE PUSE.ASM         ;Use Command
        INCLUDE PZTAPE.ASM       ;Cassette Tape Routines
        INCLUDE COMDAT.ASM       ;Initialization Data
        INCLUDE TOKEN.ASM        ;Token Tables
        INCLUDE DTABAS.ASM       ;Database Definitions
        INCLUDE SWCHAR.ASM       ;Software Character Table
        INCLUDE VOBJ.ASM         ;Object Vector Lists
        INCLUDE VARC.ASM         ;Architectural Vector Lists
        INCLUDE VERT.ASM         ;Vertical Feature Vector Lists
        INCLUDE D3.ASM           ;Creature Vector List (I)
        INCLUDE D4.ASM           ;Creature Vector List (II)
        INCLUDE KSK.ASM          ;Good Use of leftover Bytes
;
;   End of program
;
;;;;;        END				