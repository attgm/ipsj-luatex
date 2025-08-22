% ipsj-luatex.cls
% 
% IPSJ Journal class file for LuaTeX based on jlreq using expl3
% Copyright (C) 2025
%
% Based on ipsj.cls (C) 2012 Information Processing Society of Japan
% and jlreq class

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ipsj-luatex}[2025/08/19 v2.0 IPSJ class for LuaTeX with expl3]

% Engine check
\RequirePackage{iftex}
\RequireLuaTeX

% Load expl3 first
\RequirePackage{expl3}
\RequirePackage{xparse}
\RequirePackage{l3keys2e}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start expl3 syntax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExplSyntaxOn

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants and variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Boolean flags for options
\bool_new:N \g__ipsj_submit_bool
\bool_new:N \g__ipsj_proof_bool
\bool_new:N \g__ipsj_layout_bool
\bool_new:N \g__ipsj_english_bool
\bool_new:N \g__ipsj_technote_bool
\bool_new:N \g__ipsj_preface_bool
\bool_new:N \g__ipsj_techrep_bool
\bool_new:N \g__ipsj_sigrecommended_bool
\bool_new:N \g__ipsj_invited_bool
\bool_new:N \g__ipsj_online_bool
\bool_new:N \g__ipsj_draft_bool
\bool_new:N \g__ipsj_noauthor_bool
\bool_new:N \g__ipsj_abstract_bool

% Transaction journal flags
\bool_new:N \g__ipsj_PRO_bool
\bool_new:N \g__ipsj_ACS_bool
\bool_new:N \g__ipsj_TOD_bool
\bool_new:N \g__ipsj_TOM_bool
\bool_new:N \g__ipsj_CVA_bool
\bool_new:N \g__ipsj_TBIO_bool
\bool_new:N \g__ipsj_SLDM_bool
\bool_new:N \g__ipsj_CDS_bool
\bool_new:N \g__ipsj_DC_bool
\bool_new:N \g__ipsj_DCON_bool
\bool_new:N \g__ipsj_TCE_bool
\bool_new:N \g__ipsj_JIP_bool

% Paper type flags
\bool_new:N \g__ipsj_research_bool
\bool_new:N \g__ipsj_short_bool
\bool_new:N \g__ipsj_systems_bool
\bool_new:N \g__ipsj_services_bool
\bool_new:N \g__ipsj_devices_bool
\bool_new:N \g__ipsj_practice_bool
\bool_new:N \g__ipsj_content_bool
\bool_new:N \g__ipsj_data_bool
\bool_new:N \g__ipsj_survey_bool
\bool_new:N \g__ipsj_express_bool
\bool_new:N \g__ipsj_system_bool

% Journal type variable
\tl_new:N \g__ipsj_journal_tl

% Text storage variables
\tl_new:N \g__ipsj_title_jp_tl
\tl_new:N \g__ipsj_title_en_tl
\tl_new:N \g__ipsj_abstract_jp_tl
\tl_new:N \g__ipsj_abstract_en_tl
\tl_new:N \g__ipsj_keyword_jp_tl
\tl_new:N \g__ipsj_keyword_en_tl

% Date variables
\tl_new:N \g__ipsj_received_tl
\tl_new:N \g__ipsj_rereceived_tl
\tl_new:N \g__ipsj_rerereceived_tl
\tl_new:N \g__ipsj_accepted_tl
\tl_new:N \g__ipsj_presented_tl

% Editor variable
\tl_new:N \g__ipsj_editor_tl

% Author and affiliation management
\int_new:N \g__ipsj_author_count_int
\int_new:N \g__ipsj_affiliation_count_int
\seq_new:N \g__ipsj_authors_seq
\seq_new:N \g__ipsj_authors_en_seq
\seq_new:N \g__ipsj_affiliations_seq
\seq_new:N \g__ipsj_paffiliations_seq
\prop_new:N \g__ipsj_affiliation_labels_prop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Japanese typography dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\dim_new:N \JQ
\dim_set:Nn \JQ { 0.7392507pt }
\dim_new:N \h
\dim_set:Nn \h { 0.25mm }
\dim_new:N \Q
\dim_set:Nn \Q { 0.71144pt }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables for author output function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\int_new:N \l_ipsj_offset_email_int
\int_new:N \l_ipsj_count_int
\int_new:N \l_ipsj_tempcnta_int
\int_new:N \l_ipsj_tempcntb_int
\tl_new:N \l_ipsj_temp_tl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Key definitions for l3keys2e
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\keys_define:nn { ipsj }
{
  % Basic options
  submit       .bool_gset:N = \g__ipsj_submit_bool,
  proof        .bool_gset:N = \g__ipsj_proof_bool,
  layout       .bool_gset:N = \g__ipsj_layout_bool,
  english      .bool_gset:N = \g__ipsj_english_bool,
  technote     .bool_gset:N = \g__ipsj_technote_bool,
  preface      .bool_gset:N = \g__ipsj_preface_bool,
  techrep      .bool_gset:N = \g__ipsj_techrep_bool,
  sigrecommended .bool_gset:N = \g__ipsj_sigrecommended_bool,
  invited      .bool_gset:N = \g__ipsj_invited_bool,
  online       .bool_gset:N = \g__ipsj_online_bool,
  draft        .bool_gset:N = \g__ipsj_draft_bool,
  noauthor     .bool_gset:N = \g__ipsj_noauthor_bool,
  abstract     .bool_gset:N = \g__ipsj_abstract_bool,
  
  % Transaction journals
  PRO          .code:n = { \bool_gset_true:N \g__ipsj_PRO_bool \tl_gset:Nn \g__ipsj_journal_tl { PRO } },
  ACS          .code:n = { \bool_gset_true:N \g__ipsj_ACS_bool \tl_gset:Nn \g__ipsj_journal_tl { ACS } },
  TOD          .code:n = { \bool_gset_true:N \g__ipsj_TOD_bool \tl_gset:Nn \g__ipsj_journal_tl { TOD } },
  TOM          .code:n = { \bool_gset_true:N \g__ipsj_TOM_bool \tl_gset:Nn \g__ipsj_journal_tl { TOM } },
  CVA          .code:n = { \bool_gset_true:N \g__ipsj_CVA_bool \bool_gset_true:N \g__ipsj_english_bool \tl_gset:Nn \g__ipsj_journal_tl { CVA } },
  TBIO         .code:n = { \bool_gset_true:N \g__ipsj_TBIO_bool \bool_gset_true:N \g__ipsj_english_bool \tl_gset:Nn \g__ipsj_journal_tl { TBIO } },
  SLDM         .code:n = { \bool_gset_true:N \g__ipsj_SLDM_bool \bool_gset_true:N \g__ipsj_english_bool \tl_gset:Nn \g__ipsj_journal_tl { SLDM } },
  CDS          .code:n = { \bool_gset_true:N \g__ipsj_CDS_bool \tl_gset:Nn \g__ipsj_journal_tl { CDS } },
  DC           .code:n = { \bool_gset_true:N \g__ipsj_DC_bool \tl_gset:Nn \g__ipsj_journal_tl { DC } },
  DCON         .code:n = { \bool_gset_true:N \g__ipsj_DCON_bool \tl_gset:Nn \g__ipsj_journal_tl { DCON } },
  TCE          .code:n = { \bool_gset_true:N \g__ipsj_TCE_bool \tl_gset:Nn \g__ipsj_journal_tl { TCE } },
  JIP          .code:n = { \bool_gset_true:N \g__ipsj_JIP_bool \bool_gset_true:N \g__ipsj_english_bool \tl_gset:Nn \g__ipsj_journal_tl { JIP } },
  
  % Paper types
  Research     .bool_gset:N = \g__ipsj_research_bool,
  Short        .bool_gset:N = \g__ipsj_short_bool,
  systems      .bool_gset:N = \g__ipsj_systems_bool,
  services     .bool_gset:N = \g__ipsj_services_bool,
  devices      .bool_gset:N = \g__ipsj_devices_bool,
  Practice     .bool_gset:N = \g__ipsj_practice_bool,
  Content      .bool_gset:N = \g__ipsj_content_bool,
  Data         .bool_gset:N = \g__ipsj_data_bool,
  Survey       .bool_gset:N = \g__ipsj_survey_bool,
  Express      .bool_gset:N = \g__ipsj_express_bool,
  system       .bool_gset:N = \g__ipsj_system_bool,
  
  % Pass unknown options to jlreq
  unknown      .code:n = { \PassOptionsToClass{\l_keys_key_tl}{jlreq} }
}

% Process options
\ProcessKeysOptions { ipsj }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load base class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LoadClass[
  paper=a4paper,
  fontsize=9bp,
  line_length=26zw,
  number_of_lines=46,
  column_gap=2zw,
  twocolumn,
  open_bracket_pos=nibu_tentsuki,
  head_space=22mm,
  foot_space=25mm
]{jlreq}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Required packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{luatexja}
\RequirePackage{luatexja-fontspec}
\RequirePackage{graphicx}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{url}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Font settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\bool_if:NTF \g__ipsj_submit_bool
{
  % Use standard fonts for submission
  \setmainfont{Latin~Modern~Roman}
  \setsansfont{Latin~Modern~Sans}
  \setmonofont{Latin~Modern~Mono}
  \setmainjfont{Noto~Serif~CJK~JP}
  \setsansjfont{Noto~Sans~CJK~JP}
}
{
  % Use high-quality fonts for publication
  \setmainfont{Times~New~Roman}
  \setsansfont{Arial}
  \setmonofont{Courier~New}
  \setmainjfont{Noto~Serif~CJK~JP}
  \setsansjfont{Noto~Sans~CJK~JP}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Counter definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{巻数}
\newcounter{号数}
\newcounter{月数}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Public interface functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Title commands
\RenewDocumentCommand \title { m }
{
  \tl_gset:Nn \g__ipsj_title_jp_tl { #1 }
}

\NewDocumentCommand \etitle { m }
{
  \tl_gset:Nn \g__ipsj_title_en_tl { #1 }
}

% Abstract and keyword commands
\NewDocumentCommand \jabstract { m }
{
  \tl_gset:Nn \g__ipsj_abstract_jp_tl { #1 }
}

\NewDocumentCommand \eabstract { m }
{
  \tl_gset:Nn \g__ipsj_abstract_en_tl { #1 }
}

\NewDocumentCommand \jkeyword { m }
{
  \tl_gset:Nn \g__ipsj_keyword_jp_tl { #1 }
}

\NewDocumentCommand \ekeyword { m }
{
  \tl_gset:Nn \g__ipsj_keyword_en_tl { #1 }
}

% Affiliation commands
\NewDocumentCommand \affiliate { m m }
{
  \int_gincr:N \g__ipsj_affiliation_count_int
  \seq_gput_right:Nn \g__ipsj_affiliations_seq { #2 }
  \prop_gput:Nnn \g__ipsj_affiliation_labels_prop { #1 } { \int_use:N \g__ipsj_affiliation_count_int }
}

\NewDocumentCommand \paffiliate { m m }
{
  \int_gincr:N \g__ipsj_affiliation_count_int
  \seq_gput_right:Nn \g__ipsj_paffiliations_seq { 現在，#2 }
  \prop_gput:Nnn \g__ipsj_affiliation_labels_prop { #1 } { \int_use:N \g__ipsj_affiliation_count_int }
}

% Author command
\RenewDocumentCommand \author { m m m o }
{
  \int_gincr:N \g__ipsj_author_count_int
  \__ipsj_add_author:nnnn { #1 } { #2 } { #3 } { #4 }
}

\cs_new:Npn \__ipsj_add_author:nnnn #1 #2 #3 #4
{
  \tl_new:c { l__ipsj_author_ \int_use:N \g__ipsj_author_count_int _affil_tl }
  \tl_set:cn { l__ipsj_author_ \int_use:N \g__ipsj_author_count_int _affil_tl } { #3 }
  
  % Process affiliation list
  \tl_new:c { l__ipsj_author_ \int_use:N \g__ipsj_author_count_int _affil_num_tl }
  \__ipsj_process_affiliations:n { #3 }
  \tl_set:cx { l__ipsj_author_ \int_use:N \g__ipsj_author_count_int _affil_num_tl } { \l__ipsj_temp_affil_num_tl }
  
  % Build author string
  \tl_set:Nn \l__ipsj_temp_author_tl { #1 }
  \tl_put_right:Nx \l__ipsj_temp_author_tl { \exp_not:n { $ } \c_math_superscript_token { \tl_use:c { l__ipsj_author_ \int_use:N \g__ipsj_author_count_int _affil_num_tl } } \exp_not:n { $ } }
  
  % Add email if provided
  \IfValueT { #4 }
  {
    \tl_put_right:Nn \l__ipsj_temp_author_tl { \footnote{#4} }
  }
  
  \seq_gput_right:NV \g__ipsj_authors_seq \l__ipsj_temp_author_tl
  \seq_gput_right:Nn \g__ipsj_authors_en_seq { #2 }
}

\cs_new:Npn \__ipsj_process_affiliations:n #1
{
  \tl_clear:N \l__ipsj_temp_affil_num_tl
  \clist_map_inline:nn { #1 }
  {
    \prop_get:NnN \g__ipsj_affiliation_labels_prop { ##1 } \l__ipsj_temp_num_tl
    \tl_if_empty:NF \l__ipsj_temp_affil_num_tl
    {
      \tl_put_right:Nn \l__ipsj_temp_affil_num_tl { , }
    }
    \tl_put_right:NV \l__ipsj_temp_affil_num_tl \l__ipsj_temp_num_tl
  }
}

% Temporary variables for author processing
\tl_new:N \l__ipsj_temp_author_tl
\tl_new:N \l__ipsj_temp_affil_num_tl
\tl_new:N \l__ipsj_temp_num_tl

% Date commands
\NewDocumentCommand \受付 { m m m }
{
  \tl_gset:Nn \g__ipsj_received_tl { #1年#2月#3日受付 }
}

\NewDocumentCommand \再受付 { m m m }
{
  \tl_gset:Nn \g__ipsj_rereceived_tl { #1年#2月#3日再受付 }
}

\NewDocumentCommand \再再受付 { m m m }
{
  \tl_gset:Nn \g__ipsj_rerereceived_tl { #1年#2月#3日再々受付 }
}

\NewDocumentCommand \採録 { m m m }
{
  \tl_gset:Nn \g__ipsj_accepted_tl { #1年#2月#3日採録 }
}

\NewDocumentCommand \発表 { m m m }
{
  \tl_gset:Nn \g__ipsj_presented_tl { #1年#2月#3日発表 }
}

% English date commands
\NewDocumentCommand \received { m m m }
{
  \tl_gset:Nn \g__ipsj_received_tl { Received:~#2/#3/#1 }
}

\NewDocumentCommand \rereceived { m m m }
{
  \tl_gset:Nn \g__ipsj_rereceived_tl { Revised:~#2/#3/#1 }
}

\NewDocumentCommand \rerereceived { m m m }
{
  \tl_gset:Nn \g__ipsj_rerereceived_tl { Re-revised:~#2/#3/#1 }
}

\NewDocumentCommand \accepted { m m m }
{
  \tl_gset:Nn \g__ipsj_accepted_tl { Accepted:~#2/#3/#1 }
}

\NewDocumentCommand \Presented { m m m }
{
  \tl_gset:Nn \g__ipsj_presented_tl { Presented:~#2/#3/#1 }
}

% Editor command
\NewDocumentCommand \Editor { m }
{
  \tl_gset:Nn \g__ipsj_editor_tl { #1 }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make title implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  {
    \group_begin:
    \int_zero:N \l_ipsj_offset_email_int
    \int_set:Nn \l_ipsj_count_int { 1 }
    \int_incr:N \g__ipsj_author_count_int
    
    \int_while_do:nNnn { \l_ipsj_count_int } < { \g__ipsj_author_count_int }
      {
        \mbox
          {
            \bool_if:NTF \g_ipsj_english_bool
              {
                \use:c { authorname \int_use:N \l_ipsj_count_int }
              }
              {
                \use:c { #1 authorname \int_use:N \l_ipsj_count_int }
              }
            
            % Add author labels (affiliations)
            \null
            \int_set:Nn \l_ipsj_tempcnta_int 
              { \use:c { authorlabel@num@ \int_use:N \l_ipsj_count_int } }
            \int_incr:N \l_ipsj_tempcnta_int
            \int_set:Nn \l_ipsj_tempcntb_int { 1 }
            
            \group_begin:
            \int_while_do:nNnn { \l_ipsj_tempcntb_int } < { \l_ipsj_tempcnta_int }
              {
                \tl_set:Nx \l_ipsj_temp_tl 
                  { \use:c { authorlabel \int_use:N \l_ipsj_count_int @ \int_use:N \l_ipsj_tempcntb_int } }
                
                \textsuperscript
                  {
                    \use:c { #1 labelfont }
                    % Check if affiliate exists, otherwise use paffiliate
                    \cs_if_exist:cTF { affiliate@num@ \l_ipsj_temp_tl }
                      {
                        \use:c { affiliate@num@ \l_ipsj_temp_tl }
                      }
                      {
                        \use:c { paffiliate@num@ \l_ipsj_temp_tl }
                      }
                    \ipsj_comma_or_relax_affilabel:
                  }
                \int_incr:N \l_ipsj_tempcntb_int
              }
            \group_end:
            
            % Add email labels
            \int_set:Nn \l_ipsj_tempcnta_int 
              { \use:c { authoremail@num@ \int_use:N \l_ipsj_count_int } }
            \int_compare:nNnF { \l_ipsj_tempcnta_int } = { 0 }
              { \textsuperscript{,} }
            \int_incr:N \l_ipsj_tempcnta_int
            \int_set:Nn \l_ipsj_tempcntb_int { 1 }
            
            \int_while_do:nNnn { \l_ipsj_tempcntb_int } < { \l_ipsj_tempcnta_int }
              {
                \group_begin:
                \int_add:Nn \l_ipsj_tempcntb_int { \l_ipsj_offset_email_int }
                \textsuperscript
                  {
                    \use:c { #1 labelfont }
                    \int_to_alph:n { \l_ipsj_tempcntb_int } \rparen
                    \ipsj_comma_or_relax_email:
                  }
                \group_end:
                \int_incr:N \l_ipsj_tempcntb_int
              }
            
            \int_decr:N \l_ipsj_tempcntb_int
            \int_gadd:Nn \l_ipsj_offset_email_int { \l_ipsj_tempcntb_int }
          }
        
        \use:c { #1 break@or@oneskip }
        \int_incr:N \l_ipsj_count_int
      }
    \group_end:
  }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make title implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make title implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\skip_new:N \shubetutitlesep
\skip_set:Nn \shubetutitlesep { 6.2mm } % default 10mm
\skip_new:N \JEhonbunsep
\skip_set:Nn \JEhonbunsep { 13.7mm } % default 15mm

\skip_new:N \Jtitlejauthorsep
\skip_set:Nn \Jtitlejauthorsep { 9mm } % default 10mm
\skip_new:N \Jauthorjreceivesep
\skip_set:Nn \Jauthorjreceivesep { 6.5mm } % default 7mm
\skip_new:N \Jreceivejabstsep
\skip_set:Nn \Jreceivejabstsep { 2.5mm } % default 5mm
\skip_new:N \Jabstsepjkeyword
\skip_set:Nn \Jabstsepjkeyword { 5.5mm } % default 5mm
\skip_new:N \Jkeywordetitle
\skip_set:Nn \Jkeywordetitle { 14.2mm } % default 16mm
\skip_new:N \Jetitleeauthor
\skip_set:Nn \Jetitleeauthor { 5.5mm } % default 7mm
\skip_new:N \Jeauthorereceivesep
\skip_set:Nn \Jeauthorereceivesep { 5.5mm } % default 6.5mm
\skip_new:N \Jereceiveeabstsep
\skip_set:Nn \Jereceiveeabstsep { 1.5mm } % default 4.5mm
\skip_new:N \Jeabstekeywordsep
\skip_set:Nn \Jeabstekeywordsep { 5mm } % default 5mm

%%

\def\jtitlefont{ \fontsize{26\JQ}{34\h} \bfseries\gtfamily }
\def\etitlefont{ \fontsize{20\Q}{22\h}\mathversion{bold}\selectfont }

\def\authorfont{ \fontsize{16\JQ}{22\h} }
\def\eauthorfont{ \fontsize{14\JQ}{18\h} }

\def\abstractfont{ \fontsize{12\JQ}{18\h} }
\def\eabstractfont{ \fontsize{12\Q}{15\h} }
\def\keywordfont{ \fontsize{12\JQ}{15\h} }
\def\ekeywordfont{ \fontsize{12\Q}{15\h} }
%%

\RenewDocumentCommand \maketitle { }
{
  \twocolumn[
    \begin{center}
      \__ipsj_make_title_content:
    \end{center}
    \vskip 2em
  ]
}

\cs_new:Npn \__ipsj_make_title_content:
{
  \vskip\shubetutitlesep  % Title
  { \jtitlefont \tl_use:N \g__ipsj_title_jp_tl } \par
  \vskip\Jtitlejauthorsep
  
  \seq_if_empty:NF \g__ipsj_authors_seq % Authors
  {
    { \authorfont \seq_use:Nn \g__ipsj_authors_seq { , } } \par
    \vskip\Jauthorjreceivesep
  }
  \__ipsj_print_dates:
  \vskip\Jreceivejabstsep%
    \__ipsj_print_abstract:
  \vskip\Jabstsepjkeyword
  \__ipsj_print_keyword:
  \vskip\Jkeywordetitle
  {\etitlefont \tl_use:N \g__ipsj_title_en_tl } \par
  \vskip\Jtitlejauthorsep
  \seq_if_empty:NF \g__ipsj_authors_seq % Authors
  { \authorfont \authoroutput {} } \par
    \vskip\Jauthorjreceivesep
  \__ipsj_print_dates:
  \vskip\Jreceivejabstsep
  \__ipsj_print_eabstract:
  \vskip\Jabstsepjkeyword
  \__ipsj_print_ekeyword:
  % Affiliations
  \__ipsj_print_affiliations:
  \vskip\JEhonbunsep  
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author output function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\cs_new:Npn \authoroutput #1
{
  \group_begin:
  \tl_set:Nn \l_ipsj_prefix_tl { #1 }
  \int_zero:N \l_ipsj_offset_email_int
  \int_set:Nn \l_ipsj_count_int { 1 }
  \int_incr:N \g__ipsj_author_count_int
  
  \int_while_do:nNnn { \l_ipsj_count_int } < { \g__ipsj_author_count_int }
  {
    \mbox
    {
      \bool_if:NTF \g__ipsj_english_bool
      {
        \use:c { authorname \int_use:N \l_ipsj_count_int }
      }
      {
        \use:c { \l_ipsj_prefix_tl authorname \int_use:N \l_ipsj_count_int }
      }
      
      % Add author labels (affiliations)
      \null
      \cs_if_exist:cT { authorlabel@num@ \int_use:N \l_ipsj_count_int }
      {
        \int_set:Nn \l_ipsj_tempcnta_int 
        { \use:c { authorlabel@num@ \int_use:N \l_ipsj_count_int } }
        \int_incr:N \l_ipsj_tempcnta_int
        \int_set:Nn \l_ipsj_tempcntb_int { 1 }
        
        \group_begin:
        \int_while_do:nNnn { \l_ipsj_tempcntb_int } < { \l_ipsj_tempcnta_int }
        {
          \cs_if_exist:cT { authorlabel \int_use:N \l_ipsj_count_int @ \int_use:N \l_ipsj_tempcntb_int }
          {
            \tl_set:Nx \l_ipsj_temp_tl 
            { \use:c { authorlabel \int_use:N \l_ipsj_count_int @ \int_use:N \l_ipsj_tempcntb_int } }
            
            \textsuperscript
            {
              \use:c { #1 labelfont }
              % Check if affiliate exists, otherwise use paffiliate
              \cs_if_exist:cTF { affiliate@num@ \l_ipsj_temp_tl }
              {
                \use:c { affiliate@num@ \l_ipsj_temp_tl }
              }
              {
                \cs_if_exist:cT { paffiliate@num@ \l_ipsj_temp_tl }
                {
                  \use:c { paffiliate@num@ \l_ipsj_temp_tl }
                }
              }
              \ipsj_comma_or_relax_affilabel:
            }
          }
          \int_incr:N \l_ipsj_tempcntb_int
        }
        \group_end:
      }
      
      % Add email labels
      \cs_if_exist:cT { authoremail@num@ \int_use:N \l_ipsj_count_int }
      {
        \int_set:Nn \l_ipsj_tempcnta_int 
        { \use:c { authoremail@num@ \int_use:N \l_ipsj_count_int } }
        \int_compare:nNnF { \l_ipsj_tempcnta_int } = { 0 }
        { \textsuperscript{,} }
        \int_incr:N \l_ipsj_tempcnta_int
        \int_set:Nn \l_ipsj_tempcntb_int { 1 }
        
        \int_while_do:nNnn { \l_ipsj_tempcntb_int } < { \l_ipsj_tempcnta_int }
        {
          \group_begin:
          \int_add:Nn \l_ipsj_tempcntb_int { \l_ipsj_offset_email_int }
          \textsuperscript
          {
            \use:c { #1 labelfont }
            \int_to_alph:n { \l_ipsj_tempcntb_int } )
            \ipsj_comma_or_relax_email:
          }
          \group_end:
          \int_incr:N \l_ipsj_tempcntb_int
        }
        
        \int_decr:N \l_ipsj_tempcntb_int
        \int_gadd:Nn \l_ipsj_offset_email_int { \l_ipsj_tempcntb_int }
      }
    }
    
    \cs_if_exist:cT { #1 break@or@oneskip }
    {
      \use:c { #1 break@or@oneskip }
    }
    \int_incr:N \l_ipsj_count_int
  }
  \group_end:
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper functions for authoroutput
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\cs_new:Npn \ipsj_comma_or_relax_affilabel:
{
  \int_set:Nn \l_tmpa_int { \l_ipsj_tempcnta_int }
  \int_decr:N \l_tmpa_int
  \int_compare:nNnF { \l_tmpa_int } = { \l_ipsj_tempcntb_int }
  { , }
}

\cs_new:Npn \ipsj_comma_or_relax_email:
{
  \int_set:Nn \l_tmpa_int { \l_ipsj_tempcnta_int }
  \int_decr:N \l_tmpa_int
  \int_set:Nn \l_tmpb_int { \l_ipsj_tempcntb_int }
  \int_sub:Nn \l_tmpb_int { \l_ipsj_offset_email_int }
  \int_compare:nNnF { \l_tmpa_int } = { \l_tmpb_int }
  { , }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    {
      \group_begin:
      \int_zero:N \l_ipsj_offset_email_int
      \int_set:Nn \l_ipsj_count_int { 1 }
      \int_incr:N \g__ipsj_author_count_int
      
      \int_while_do:nNnn { \l_ipsj_count_int } < { \g__ipsj_author_count_int }
        {
          \mbox
            {
              \bool_if:NTF \g__ipsj_english_bool
                {
                  \use:c { authorname \int_use:N \l_ipsj_count_int }
                }
                {
                  \use:c { #1 authorname \int_use:N \l_ipsj_count_int }
                }
              
              % Add author labels (affiliations)
              \null
              \cs_if_exist:cT { authorlabel@num@ \int_use:N \l_ipsj_count_int }
                {
                  \int_set:Nn \l_ipsj_tempcnta_int 
                    { \use:c { authorlabel@num@ \int_use:N \l_ipsj_count_int } }
                  \int_incr:N \l_ipsj_tempcnta_int
                  \int_set:Nn \l_ipsj_tempcntb_int { 1 }
                  
                  \group_begin:
                  \int_while_do:nNnn { \l_ipsj_tempcntb_int } < { \l_ipsj_tempcnta_int }
                    {
                      \cs_if_exist:cT { authorlabel \int_use:N \l_ipsj_count_int @ \int_use:N \l_ipsj_tempcntb_int }
                        {
                          \tl_set:Nx \l_ipsj_temp_tl 
                            { \use:c { authorlabel \int_use:N \l_ipsj_count_int @ \int_use:N \l_ipsj_tempcntb_int } }
                          
                          \textsuperscript
                            {
                              \use:c { #1 labelfont }
                              % Check if affiliate exists, otherwise use paffiliate
                              \cs_if_exist:cTF { affiliate@num@ \l_ipsj_temp_tl }
                                {
                                  \use:c { affiliate@num@ \l_ipsj_temp_tl }
                                }
                                {
                                  \cs_if_exist:cT { paffiliate@num@ \l_ipsj_temp_tl }
                                    {
                                      \use:c { paffiliate@num@ \l_ipsj_temp_tl }
                                    }
                                }
                              \ipsj_comma_or_relax_affilabel:
                            }
                        }
                      \int_incr:N \l_ipsj_tempcntb_int
                    }
                  \group_end:
                }
              
              % Add email labels
              \cs_if_exist:cT { authoremail@num@ \int_use:N \l_ipsj_count_int }
                {
                  \int_set:Nn \l_ipsj_tempcnta_int 
                    { \use:c { authoremail@num@ \int_use:N \l_ipsj_count_int } }
                  \int_compare:nNnF { \l_ipsj_tempcnta_int } = { 0 }
                    { \textsuperscript{,} }
                  \int_incr:N \l_ipsj_tempcnta_int
                  \int_set:Nn \l_ipsj_tempcntb_int { 1 }
                  
                  \int_while_do:nNnn { \l_ipsj_tempcntb_int } < { \l_ipsj_tempcnta_int }
                    {
                      \group_begin:
                      \int_add:Nn \l_ipsj_tempcntb_int { \l_ipsj_offset_email_int }
                      \textsuperscript
                        {
                          \use:c { #1 labelfont }
                          \int_to_alph:n { \l_ipsj_tempcntb_int } )
                          \ipsj_comma_or_relax_email:
                        }
                      \group_end:
                      \int_incr:N \l_ipsj_tempcntb_int
                    }
                  
                  \int_decr:N \l_ipsj_tempcntb_int
                  \int_gadd:Nn \l_ipsj_offset_email_int { \l_ipsj_tempcntb_int }
                }
            }
          
          \cs_if_exist:cT { #1 break@or@oneskip }
            {
              \use:c { #1 break@or@oneskip }
            }
          \int_incr:N \l_ipsj_count_int
    }
  \group_end:
}

\cs_new:Npn \__ipsj_print_affiliations:
{
  \seq_if_empty:NF \g__ipsj_affiliations_seq
  {
    { \footnotesize
      \int_set:Nn \l_tmpa_int { 1 }
      \seq_map_inline:Nn \g__ipsj_affiliations_seq
      {
        $\c_math_superscript_token { \int_use:N \l_tmpa_int }$##1
        \int_incr:N \l_tmpa_int
        \seq_if_empty:NF \g__ipsj_paffiliations_seq
        {
          \seq_map_inline:Nn \g__ipsj_paffiliations_seq
          {
            , $\c_math_superscript_token { \int_use:N \l_tmpa_int }$####1
            \int_incr:N \l_tmpa_int
          }
        }
      }
    }
  }
}

\cs_new:Npn \__ipsj_print_abstract:
{
    \begin{minipage}{0.8\textwidth}
        \abstractfont
        \textbf{概要：}\tl_use:N \g__ipsj_abstract_jp_tl \par
    \end{minipage}\par
}

\cs_new:Npn \__ipsj_print_keyword:
{
    \begin{minipage}{0.8\textwidth}
        \keywordfont
        \textbf{キーワード：} \tl_use:N \g__ipsj_keyword_jp_tl \par
    \end{minipage}\par
}

\cs_new:Npn \__ipsj_print_eabstract:
{ 
    \begin{minipage}{0.8\textwidth}
        \eabstractfont
        {\bfseries\itshape Abstract:}\hskip.5em
        \tl_use:N \g__ipsj_abstract_en_tl \par
    \end{minipage}\par
}

\cs_new:Npn \__ipsj_print_ekeyword:
{
    \begin{minipage}{0.8\textwidth}
        \ekeywordfont
        \textbf{Keywords:}\hskip.5em
        \c_space_tl \tl_use:N \g__ipsj_keyword_en_tl \par
    \end{minipage}\par
}

\cs_new:Npn \__ipsj_print_dates:
{
  { \footnotesize
    \tl_use:N \g__ipsj_received_tl
    \tl_if_empty:NF \g__ipsj_rereceived_tl { , \tl_use:N \g__ipsj_rereceived_tl }
    \tl_if_empty:NF \g__ipsj_rerereceived_tl { , \tl_use:N \g__ipsj_rerereceived_tl }
    \tl_if_empty:NF \g__ipsj_accepted_tl { , \tl_use:N \g__ipsj_accepted_tl }
    \tl_if_empty:NF \g__ipsj_presented_tl { , \tl_use:N \g__ipsj_presented_tl }
  } \par
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure and table commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NewDocumentCommand \figref { m }
{
  図\ref{#1}
}

\NewDocumentCommand \tabref { m }
{
  表\ref{#1}
}

\NewDocumentCommand \figrefstar { m }
{
  \ref{#1}
}

\NewDocumentCommand \tabrefstar { m }
{
  \ref{#1}
}

\NewDocumentCommand \ecaption { m }
{
  \bool_if:NTF \g__ipsj_english_bool
  {
    \caption{#1}
  }
  {
    \addtocounter{figure}{-1}
    \addtocounter{table}{-1}
    { \small #1 }
  }
}

\NewDocumentCommand \CaptionType { m }
{
  \str_if_eq:nnTF { #1 } { figure }
  {
    \def\@captype{figure}
  }
  {
    \str_if_eq:nnT { #1 } { table }
    {
      \def\@captype{table}
    }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Special environments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NewDocumentEnvironment { acknowledgment } { }
{
  \section*{謝辞}
}
{
}

\NewDocumentEnvironment { biography } { }
{
  \section*{著者紹介}
  \begin{description}
}
{
  \end{description}
}

\NewDocumentCommand \profile { m m m }
{
  \item[#2] #3
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bibliography formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewenvironment{thebibliography}[1]
{
  \section*{参考文献}
  \list{\@biblabel{\@arabic\c@enumiv}}
    {\settowidth\labelwidth{\@biblabel{#1}}
     \leftmargin\labelwidth
     \advance\leftmargin\labelsep
     \@openbib@code
     \usecounter{enumiv}
     \let\p@enumiv\@empty
     \renewcommand\theenumiv{\@arabic\c@enumiv}}
  \sloppy
  \clubpenalty4000
  \@clubpenalty \clubpenalty
  \widowpenalty4000
  \sfcode`\.\@m}
{\def\@noitemerr
  {\@latex@warning{Empty `thebibliography' environment}}%
  \endlist}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of expl3 syntax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%