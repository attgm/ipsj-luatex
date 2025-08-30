% ipsj-luatex.cls
% 
% IPSJ Journal class file for LuaTeX based on jlreq using expl3
% Copyright (C) 2025
%
% Based on ipsj.cls (C) 2012 Information Processing Society of Japan
% and jlreq class

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ipsj-luatex}[2025/08/19 v1.0 IPSJ class for LuaTeX with expl3]

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

\bool_new:N \g__ipsj_preprint_bool

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
\tl_new:N \g__ipsj_paper_type_tl
\tl_new:N \g__ipsj_paper_type_name_tl

% Journal type variable
\tl_new:N \g__ipsj_journal_tl

\tl_new:N \g__ipsj_journal_header_tl
\tl_new:N \g__ipsj_appendix_name_tl
\tl_new:N \g__ipsj_reference_name_tl
\tl_new:N \g__ipsj_Acknowledgments_name_tl

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
\int_new:N \g__ipsj_paffiliation_count_int
\seq_new:N \g__ipsj_authors_seq
\seq_new:N \g__ipsj_authors_en_seq
\seq_new:N \g__ipsj_authors_affil_seq
\seq_new:N \g__ipsj_authors_email_seq
\seq_new:N \g__ipsj_affiliations_seq
\seq_new:N \g__ipsj_paffiliations_seq
\prop_new:N \g__ipsj_affiliation_labels_prop
\prop_new:N \g__ipsj_affiliation_indexes_prop
\prop_new:N \g__ipsj_paffiliation_indexes_prop

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
  
  preprint     .bool_gset:N = \g__ipsj_preprint_bool,

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
  Research     .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { research } },
  research     .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { research } },
  Short        .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { short } },
  short        .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { short } },
  systems      .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { systems } },
  services     .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { services } },
  devices      .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { devices } },
  Practice     .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { practice } },
  practice     .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { practice } },
  Content      .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { content } },
  content      .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { content } },
  data         .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { data } },
  Data         .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { data } },
  Survey       .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { survey } },
  survey       .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { survey } },
  Express      .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { express } },
  express      .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { express } },
  system       .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { system } },
  invited      .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { invited } },
  sigrecommended  .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { sigrecommended } },
  invitedshort    .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { invitedshort } },  
  recommendedshort  .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { recommendedshort } },
  technode          .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { technote } },
  recommendedresearch .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { recommendedresearch } },
  recommendedpractice .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { recommendedpractice } },
  recommendedcontent  .code:n = { \tl_gset:Nn \g__ipsj_paper_type_tl { recommendedcontent } },
  abstract     .code:n = { \bool_gset_true:N \g__ipsj_abstract_bool \tl_gset:Nn \g__ipsj_paper_type_tl { abstract } },     
  % Pass unknown options to jlreq
  unknown      .code:n = { \PassOptionsToClass{\l_keys_key_tl}{jlreq} }
}

% Process options
\ProcessKeysOptions { ipsj }

\cs_new:Npn \__ipsj_flexible_hbox:nn #1 #2
{
  \cs_if_exist:NTF \ltjsetparameter {
    \leavevmode\hbox to #1{%
      \ltjsetparameter{kanjiskip=0pt plus 1fill minus 1fill}%
      \ltjsetparameter{xkanjiskip=0pt plus 1fill minus 1fill}%
      #2
    }%
  }{
    \leavevmode\hbox to #1{%
      \spaceskip\z@ \@plus 1fill \@minus 1fill
      \xspaceskip\spaceskip #2}%
  }
}

\bool_if:NTF \g__ipsj_english_bool {
  \tl_gset:Nn \g__ipsj_appendix_name_tl { Appendix }
  \tl_gset:Nn \g__ipsj_reference_name_tl { References }
  \tl_gset:Nn \g__ipsj_Acknowledgments_name_tl { Acknowledgments }
} {
  \tl_gset:Nn \g__ipsj_appendix_name_tl { \__ipsj_flexible_hbox:nn { 5\zw } { 付録 } }
  \tl_gset:Nn \g__ipsj_reference_name_tl { 参考文献 }
  \tl_gset:Nn \g__ipsj_Acknowledgments_name_tl { 謝辞 }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load base class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  \@setfontsize\normalsize{13\JQ}{21\h}
\LoadClass[
  paper=a4,
  twocolumn,
  fontsize=9.25pt,
  line_length=26zw,
  number_of_lines=46,
  column_gap=8mm,
  open_bracket_pos=nibu_tentsuki,
  head_space=18mm
]{jlreq}

\setlength{\headheight}{ 5 mm }
\setlength{\headsep}{ 9.5mm }

\jlreqsetup {
  footnote_second_indent=2\zw,
  appendix_precode = {
    \section*{\tl_use:N \g__ipsj_appendix_name_tl}
  },
  appendix_counter = {
    section = { value = 0, the = {\arabic{section}} },
    subsection = { value = 0, the = {\arabic{subsection}} },
    subsubsection = { value = 0, the = {\arabic{subsubsection}} },
  },
  appendix_heading = {
    section = {label_format = {A.\thesection}},
    subsection = {label_format = {A.\thesection.\thesubsection}},
    subsubsection = {label_format = {A.\thesection.\thesubsection.\thesubsubsection}}
  }
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Required packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\RequirePackage{luatexja}
\RequirePackage{luatexja-fontspec}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Font settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Counter definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{volume} \c@volume\z@
\newcounter{number} \c@number\z@
\newcounter{month} \c@month\m@ne
\newcounter{year} \c@year\m@ne

\bool_if:NF \g__ipsj_english_bool {
  \cs_set_eq:cN { c@巻数 } \c@volume
  \cs_set_eq:cN { c@号数 } \c@number
  \cs_set_eq:cN { c@月数 } \c@month
  \cs_set_eq:cN { c@年数 } \c@year
}

\AtBeginDocument{\label{ipsj@firstpage}}
\AtEndDocument{%
 \clearpage
 \addtocounter{page}{-1}%
 \immediate\write\@auxout
  {\string\newlabel{ipsj@lastpage}{{}{\thepage}}}%
}

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
\RenewDocumentEnvironment { abstract } { +b }
{}
{
  \tl_gset:Nn \g__ipsj_abstract_jp_tl { #1 }
}

\NewDocumentEnvironment { eabstract } { +b }
{}{
  \tl_gset:Nn \g__ipsj_abstract_en_tl { #1 }
}

\NewDocumentEnvironment { jkeyword } { +b }
{}{
  \tl_gset:Nn \g__ipsj_keyword_jp_tl { #1 }
}

\NewDocumentEnvironment { ekeyword } { +b }
{}{
  \tl_gset:Nn \g__ipsj_keyword_en_tl { #1 }
}

% Affiliation commands
\NewDocumentCommand \affiliate { m m }
{
  \int_incr:N \g__ipsj_affiliation_count_int
  \seq_gput_right:Nn \g__ipsj_affiliations_seq { #1 }
  \prop_gput:Nnn \g__ipsj_affiliation_labels_prop { #1 } { #2 }
  \prop_gput:NnV \g__ipsj_affiliation_indexes_prop { #1 } { \g__ipsj_affiliation_count_int }
  
}

\NewDocumentCommand \paffiliate { m m }
{
  \int_incr:N \g__ipsj_paffiliation_count_int
  \seq_gput_right:Nn \g__ipsj_paffiliations_seq { #1 }
  \prop_gput:Nnn \g__ipsj_affiliation_labels_prop { #1 } { 現在，#2 }
  \prop_gput:NnV \g__ipsj_paffiliation_indexes_prop { #1 } { \g__ipsj_paffiliation_count_int }
}

% Author command
\RenewDocumentCommand \author { m m m o }
{
    \int_gincr:N \g__ipsj_author_count_int
    \__ipsj_add_author:nnnn { #1 } { #2 } { #3 } { #4 }
}

\cs_new:Npn \__ipsj_add_author:nnnn #1 #2 #3 #4
{
    \seq_put_right:Nn \g__ipsj_authors_seq { #1 }
    \seq_put_right:Nn \g__ipsj_authors_en_seq { #2 }
    \seq_put_right:Nn \g__ipsj_authors_affil_seq { #3 }
  \IfNoValueTF{#4}{
    \seq_put_right:Nn \g__ipsj_authors_email_seq { }
  }{
    \seq_put_right:Nn \g__ipsj_authors_email_seq { #4 }
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


\int_new:N \g__ipsj_base_year_int
\int_set:Nn \g__ipsj_base_year_int
{
  \str_case:VnF \g__ipsj_journal_tl {
    { JIP } { 1992 }
    { EEE } { 1992 }
    { ACS } { 2007 }
    { PRO } { 2007 }
    { TOD } { 2007 }
    { TOM } { 2007 }
    { TBIO } { 2007 }
    { CVA } { 2008 }
    { SLDM } { 2007 }
    { CDS } { 2010 }
    { DC } { 2012 }
    { DCON } { 2012 }
    { TCE } { 2014 }    
  } { 1959 }
}

\cs_new:Npn \__ipsj_month_name:
{
  \int_case:nnF {  \int_compare:nTF { \c@month < 0 } { \c@number } { \c@month } }
  {
    { 1  } { Jan. }
    { 2  } { Feb. }
    { 3  } { Mar. }
    { 4  } { Apr. }
    { 5  } { May }
    { 6  } { June }
    { 7  } { July }
    { 8  } { Aug. }
    { 9  } { Sep. }
    { 10 } { Oct. }
    { 11 } { Nov. }
    { 12 } { Dec. }
  } { ??? }
}


\cs_new:Npn \__ipsj_year:
{
  \int_compare:nTF { \c@year < 0 }
    { \int_eval:n { \g__ipsj_base_year_int + \int_use:N \c@volume } }
    { \c@year }
}

\cs_new:Npn \__ipsj_month_year: 
{
  \__ipsj_month_name:
  \skip_horizontal:n { 0.5 \Cwd }
  \__ipsj_year:
}

\tl_gset:Nn  \g__ipsj_paper_type_name_tl {
  \bool_if:NTF \g__ipsj_english_bool {
    \str_case:VnF \g__ipsj_paper_type_tl {
      { research } { Research Paper }
      { short } { Short Paper }
      { systems } { Paper on Consumer Systems } 
      { services } { Paper on Consumer Services }
      { devices } { Paper on Consumer Devices }
      { practice } { Practice Paper }
      { content } { Content Paper }
      { data } { Database/Software Paper }
      { survey } { Survey Paper }
      { express } { Express Paper }
      { system } { Systems Paper }
      { invited } { Invited Paper }
      { sigrecommended } { Recommended Paper }
      { invitedshort } { Invited Short Paper }
      { recommendedshort } { Recommended Short Paper }
      { technote } { Technical Note }
      { recommendedresearch } { Recommended Research Paper }
      { recommendedpractice } { Recommended Practice Pape }
      { recommendedcontent } { Recommended Content Paper }
      { abstract } { Presentation Abstract }
    } {
      \str_case:VnF \g__ipsj_journal_tl {
        { TCE } { Regular Paper }
        { TBIO } { Original Paper }
        { CVA } { Regular Paper }
        { SLDM } { Regular Paper }
      } { \par }
    }
  }
  {
    \str_case:VnF \g__ipsj_paper_type_tl {
      { research } { 研究論文 }
      { short } { ショートペーパー }
      { systems } { コンシューマ・システム論文 }
      { services } { コンシューマ・サービス論文 }
      { devices } { コンシューマ・デバイス論文 }
      { practice } { 産業論文 }
      { content } { 作品論文 }
      { invited } { 招待論文 }
      { sigrecommended } { \str_if_eq:VnTF \g__ipsj_journal_tl { TCE } { 研究会推薦論文 } { 推薦論文 }}
      { invitedshort } { 招待ショートペーパー }
      { recommendedshort } { 研究会推薦ショートペーパー }
      { technote } { テクニカルノート }
      { recommendedresearch } {  推薦研究論文 }
      { recommendedpractice } { 推薦産業論文 }
      { recommendedcontent } { 推薦作品論文 }
      { abstract } { 発表概要 }
    } { \str_case:VnF \g__ipsj_journal_tl {
        { TCE } { 論文 }
      } { \par }
    }
  }
}


\tl_gset:Nn  \g__ipsj_journal_header_tl {
  \bool_if:NTF \g__ipsj_english_bool {
    \str_case:VnF \g__ipsj_paper_type_tl {
      { JIP } { Journal~of~Information~Processing }
      { ACS } { IPSJ~Transactions~on~Advanced~Computing~Systems }
      { PRO } { IPSJ~Transactions~on~Programming }
      { TOD } { IPSJ~Transactions~on~Databases }
      { TOM } { IPSJ~Transactions~on~Mathematical~Modeling~and~Its~Applications }
      { TBIO } { IPSJ~Transactions~on~Bioinformatics }
      { CVA } { IPSJ~Transactions~on~Computer~Vision~and~Applications }
      { SLDM } { IPSJ~Transactions~on~System~LSI~Design~Methodology }
      { CDS } { IPSJ~Transactions~on~Consumer~Devices~\&~Systems }
      { DC } { IPSJ~Transactions~on~Digital~Content }
      { DCON } { IPSJ~Transactions~on~Digital~Content }
      { TCE } { IPSJ~Transactions~on~Computers~and~Education }    
    } { Electronic~Preprint~for~Journal~of~Information~Processing }
  }
  {
    \str_case:VnF \g__ipsj_journal_tl {
      { ACS } { 情報処理学会論文誌 \hskip12\JQ コンピューティングシステム }
      { PRO } { 情報処理学会論文誌 \hskip12\JQ プログラミング }
      { TOD } { 情報処理学会論文誌 \hskip12\JQ データベース }
      { TOM } { 情報処理学会論文誌 \hskip12\JQ  数理モデル化と応用 }
      { CDS } { 情報処理学会論文誌 \hskip12\JQ コンシューマ・デバイス\,\&\,システム }
      { DC } { 情報処理学会論文誌 \hskip12\JQ デジタルコンテンツ }
      { DCON } { 情報処理学会論文誌 \hskip12\JQ デジタルコンテンツ }
      { TCE } { 情報処理学会論文誌 \hskip12\JQ 教育とコンピュータ }    
    } { 情報処理学会論文誌 }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Page Style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\bool_if:NTF \g__ipsj_english_bool {
  \def\headinfofont { \fontsize{13\JQ}{0\h} \selectfont\sffamily\bfseries }
  \def\headnamefont { \fontsize{13\JQ}{0\h} \selectfont\sffamily\bfseries }
} {
  \def\headnamefont { \fontsize{12\JQ}{0\h} \selectfont\gtfamily\bfseries }
  \def\headinfofont { \fontsize{13\JQ}{0\h} \selectfont\sffamily\bfseries }
}
\def\headDOIfont{\fontsize{11\Q}{0\h}\sffamily\selectfont}
\def\footerfont { \fontsize{10\Q}{0\h}\normalfont\selectfont }
\def\footerpagefont { \fontsize{13\Q}{0\h}\normalfont\selectfont }

\cs_new:Npn \__ipsj_number: 
{
  \bool_if:nF
  {
    \str_if_eq_p:Vn \g__ipsj_journal_tl { CVA } ||
    \str_if_eq_p:Vn \g__ipsj_journal_tl { TBIO } ||
    \str_if_eq_p:Vn \g__ipsj_journal_tl { SLDM } ||
    \str_if_eq_p:Vn \g__ipsj_journal_tl { JIP } ||
    \bool_if_p:N \g__ipsj_preprint_bool
  }
  { \hskip1em { \headinfofont { No.\int_use:N \c@number } } }
}

\cs_new:Npn \__ipsj_doi:
{
  \smash{\raisebox{-6mm}{\rlap{\headDOIfont
  \str_case:Vn \g__ipsj_journal_tl {
    { TBIO } { [DOI: 10.2197/ipsjtbio.\number\c@volume.\pageref{ipsj@firstpage}] }
    { CVA }  { [DOI: 10.2197/ipsjtcva.\number\c@volume.\pageref{ipsj@firstpage}] }
    { SLDM } { [DOI: 10.2197/ipsjtsldm.\number\c@volume.\pageref{ipsj@firstpage}] }
    { JIP }  { [DOI: 10.2197/ipsjjip.\number\c@volume.\pageref{ipsj@firstpage}] }
  }
  }}}
}

\NewPageStyle{IPSJPageStyle}{
  yoko,
  running_head_position={ top-left },
  odd_head_format={
    \rlap{
      {\headnamefont \tl_use:N \g__ipsj_journal_header_tl}
      \hskip12\JQ{\headinfofont Vol.\number\c@volume}
      \__ipsj_number:
      \hskip12\JQ{\headinfofont \pageref{ipsj@firstpage}--\pageref{ipsj@lastpage}}\ 
      {\headinfofont ( \__ipsj_month_year: ) }
    }
    \__ipsj_doi:
  },
  odd_foot_format={
    \rlap{\footerfont \copyright \  \__ipsj_year: \  Information~Processing~Society~of~Japan}
    \hfil
    {\footerpagefont \thepage}
  }
}

%%
% Heading
%% 


\def\sectionfont{ \fontsize{16\JQ}{21\h}\selectfont\bfseries }
\def\subsectionfont{ \normalsize\selectfont\bfseries }

\RenewDocumentCommand \thesection         {} {\@arabic\c@section.}
\RenewDocumentCommand \thesubsection      {} {\thesection\@arabic\c@subsection}
\RenewDocumentCommand \thesubsubsection   {} {\thesubsection.\@arabic\c@subsubsection}
\RenewDocumentCommand \theparagraph     {} {\thesubsubsection.\@arabic\c@paragraph}
\RenewDocumentCommand \thesubparagraph  {} {\theparagraph.\@arabic\c@subparagraph}

\ModifyHeading{section}{font={\sectionfont}, lines=2.43}
\ModifyHeading{subsection}{font={\subsectionfont}, lines=1}
\ModifyHeading{subsubsection}{font={\subsectionfont}, lines=1}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make title implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\skip_new:N \shubetutitlesep
\skip_new:N \JEhonbunsep
\skip_new:N \Jtitlejauthorsep
\skip_new:N \Jauthorjreceivesep
\skip_new:N \Jreceivejabstsep
\skip_new:N \Jabstsepjkeyword
\skip_new:N \Jkeywordetitle
\skip_new:N \Jetitleeauthor
\skip_new:N \Jeauthorereceivesep
\skip_new:N \Jereceiveeabstsep
\skip_new:N \Jeabstekeywordsep

\skip_set:Nn \shubetutitlesep { 6.2mm }
\skip_set:Nn \JEhonbunsep { 13.7mm }
\skip_set:Nn \Jtitlejauthorsep { 9mm } 
\skip_set:Nn \Jauthorjreceivesep { 6.5mm }
\skip_set:Nn \Jreceivejabstsep { 2.5mm } 
\skip_set:Nn \Jabstsepjkeyword { 5.5mm }
\skip_set:Nn \Jkeywordetitle { 14.2mm } 
\skip_set:Nn \Jetitleeauthor { 5.5mm } 
\skip_set:Nn \Jeauthorereceivesep { 5.5mm } 
\skip_set:Nn \Jereceiveeabstsep { 1.5mm } 
\skip_set:Nn \Jeabstekeywordsep { 5mm } 

\def\shubetufont{ \fontsize{18\JQ}{0\h} \selectfont\bfseries\gtfamily}
\def\titlefont{ \fontsize{26\JQ}{34\h} \bfseries\gtfamily }
\def\etitlefont{ \fontsize{20\Q}{22\h} \selectfont\bfseries }
\def\authorfont{ \fontsize{16\JQ}{22\h} \selectfont }
\def\eauthorfont{ \fontsize{14\JQ}{18\h} \selectfont }
\def\abstractfont{ \fontsize{12\JQ}{18\h} \selectfont }
\def\eabstractfont{ \fontsize{12\Q}{15\h} \selectfont }
\def\keywordfont{ \fontsize{12\JQ}{15\h} \selectfont }
\def\ekeywordfont{ \fontsize{12\Q}{15\h} \selectfont }
%%

\RenewDocumentCommand \maketitle {}
{
    \par
    \begingroup
      \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
      \if@twocolumn
        \ifnum\col@number=\@ne
          \@maketitle
        \else
          \twocolumn[\@maketitle]%
        \fi
      \else
        \newpage
        \global\@topnum\z@
        \@maketitle
      \fi
      %
      \bool_if:nT {!(
        \tl_if_empty_p:o \@oddhead &&
        \tl_if_empty_p:o \@evenhead &&
        \tl_if_empty_p:o \@oddfoot &&
        \tl_if_empty_p:o \@evenfoot
      )} { \thispagestyle{IPSJPageStyle} }
      \@thanks
    \endgroup
    \jlreq@endofmaketitle
    \__ipsj_affiliate_output:
    \setcounter{footnote}{0}
    \def\thefootnote{\ifnum\c@footnote>\z@\leavevmode\lower.5ex\hbox{*}\@arabic\c@footnote\fi}
}

\RenewDocumentCommand \@maketitle { }
{
  { \shubetufont \tl_use:N \g__ipsj_paper_type_name_tl }
  \begin{center}
  \vskip\shubetutitlesep  % Title
  { \titlefont \tl_use:N \g__ipsj_title_jp_tl } \par
  \vskip\Jtitlejauthorsep
  \seq_if_empty:NF \g__ipsj_authors_seq % Authors
  \__ipsj_author_output:Nn \g__ipsj_authors_seq \authorfont
  \vskip\Jauthorjreceivesep
%  \__ipsj_print_detes:
  \vskip\Jreceivejabstsep
  \__ipsj_print_abstract:
  \vskip\Jabstsepjkeyword
  \__ipsj_print_keyword:
  \vskip\Jkeywordetitle
  \vskip\shubetutitlesep
  { \etitlefont \tl_use:N \g__ipsj_title_en_tl } \par
  \vskip\Jetitleeauthor
  \__ipsj_author_output:Nn \g__ipsj_authors_en_seq \eauthorfont
  \vskip\Jeauthorereceivesep
  %
  \vskip\Jereceiveeabstsep
  \__ipsj_print_eabstract:
  \vskip\Jeabstekeywordsep
  \__ipsj_print_ekeyword:
  \vskip\JEhonbunsep
  \end{center}
}


\int_new:N \l_idx_int
\int_new:N \l__email_idx_int
\def\rparen{)}%%

\cs_generate_variant:Nn \seq_set_split:Nnn {NnV}


\cs_new:Npn \__ipsj_author_output:Nn #1 #2
{
  \int_zero:N \l_idx_int
    \int_zero:N \l__email_idx_int
    \seq_map_inline:Nn #1 {
      \int_incr:N \l_idx_int
      {#2 ##1}
      \tl_set:Nx \l_tmpa_tl { \seq_item:Nn \g__ipsj_authors_affil_seq { \l_idx_int } }
      \seq_clear:N \l_tmpa_seq
      \tl_if_empty:NF \l_tmpa_tl {
        \seq_set_split:NnV \l__ipsj_tmp_affil_seq { , } { \l_tmpa_tl }

        \seq_map_inline:Nn \l__ipsj_tmp_affil_seq {
          \prop_get:NnNTF \g__ipsj_affiliation_indexes_prop { ####1 } \l_tmpa_int
            { \seq_put_right:NV \l_tmpa_seq { \l_tmpa_int } }
            { 
              \prop_get:NnNTF \g__ipsj_paffiliation_indexes_prop { ####1 } \l_tmpb_int
              { \seq_put_right:NV \l_tmpa_seq { \textdagger \l_tmpb_int } } { }             
            }
        }
        \tl_set:Nx \l_tmpa_tl { \seq_item:Nn \g__ipsj_authors_email_seq { \l_idx_int } }
        \tl_if_empty:NF \l_tmpa_tl {
          \int_incr:N \l__email_idx_int
          \seq_put_right:NV \l_tmpa_seq { \@alph{\l__email_idx_int}\rparen }
        }
        \seq_if_empty:NF \l_tmpa_seq {
          \textsuperscript{ \seq_use:Nn \l_tmpa_seq { , } }
        }
      }
      \hskip\zw
    }
    \par
}



\cs_new:Npn \__ipsj_affiliate_output:
{
    \renewcommand{\thefootnote}{\@arabic{\c@footnote}\protect\hphantom{\rparen}}
    \seq_map_inline:Nn \g__ipsj_affiliations_seq {
        \prop_get:NnN \g__ipsj_affiliation_labels_prop { ##1 } \l_tmpa_tl
        \prop_get:NnN \g__ipsj_affiliation_indexes_prop { ##1 } \l_tmpa_int
        \footnotetext[\l_tmpa_int]{ \l_tmpa_tl }
    }
    \renewcommand{\thefootnote}{\textdagger\@arabic{\c@footnote}}
    %\renewcommand{\thefootnote}{\fnsymbol{footnote}}
    \seq_map_inline:Nn \g__ipsj_paffiliations_seq {
        \prop_get:NnN \g__ipsj_affiliation_labels_prop { ##1 } \l_tmpa_tl
        \prop_get:NnN \g__ipsj_paffiliation_indexes_prop { ##1 } \l_tmpa_int
        \footnotetext[\l_tmpa_int]{ \l_tmpa_tl }
    }
    \renewcommand{\thefootnote}{\@alph{\c@footnote}\rparen}
    %\renewcommand{\thefootnote}{\fnsymbol{footnote}}
    \int_zero:N \l__email_idx_int
    \seq_map_inline:Nn \g__ipsj_authors_email_seq {
      \tl_set:Nx \l_tmpa_tl { ##1 }
      \tl_if_empty:NF \l_tmpa_tl {
        \int_incr:N \l__email_idx_int
        \footnotetext[\l__email_idx_int]{ \l_tmpa_tl }
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
        {\bfseries\itshape Keywords:}\hskip.5em
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
  図~\ref{#1}
}

\NewDocumentCommand \tabref { m }
{
  表~\ref{#1}
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
% Special environments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NewRuninHeading{ackheading}{1}{
  font=\normalsize\selectfont\bfseries, indent=\zw, after_label_space=\zw, number=false
}

\NewDocumentEnvironment { acknowledgment } { }
{
  \ackheading{\tl_use:N \g__ipsj_Acknowledgments_name_tl}
}
{
}


\NewDocumentEnvironment { biography } { }
{
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

\NewBlockHeading{bioheading}{1}{
  font=\normalsize\selectfont\bfseries,lines=1, number=false
}

\renewenvironment{thebibliography}[1]
{
  \subsubsection*{\g__ipsj_reference_name_tl}\par
  \bool_if:NTF \g__ipsj_english_bool {
    \footnotesize\baselineskip12\h
  } {
    \small\baselineskip15\h
  }
  \list{\@biblabel{\@arabic\c@enumiv}}
    {\settowidth\labelwidth{\@biblabel{#1}}
     \labelsep=1\zw
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
\pagestyle{IPSJPageStyle}
\def\thepage{\the\c@page}

\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%