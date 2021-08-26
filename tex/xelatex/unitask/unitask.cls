\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{unitask}[2020/08/27 v1.0.0 simple university expercise sheet document class]

\LoadClassWithOptions{scrartcl}
\makeatletter
% options
\newif\ifptable
\newif\ifutable
\DeclareOption{ptable}{\ptabletrue  \utablefalse}
\DeclareOption{utable}{\ptabletrue  \utabletrue}
\DeclareOption{ntable}{\ptablefalse \utabletrue \newcommand{\ptable}\@ptable}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}

\ExecuteOptions{ptable}
\ProcessOptions\relax

% auto import packages
\RequirePackage{scrlayer-scrpage}
\RequirePackage{xunicode}
\RequirePackage{xltxtra}
\RequirePackage{enumerate}
\RequirePackage{soul}


%---------------------------------------------%
%                 genrelle Konf.              %
%---------------------------------------------%

\newcommand*{\fach}[1]{\def\@fach{#1}}
\newcommand{\@fach}{???}

\newcommand*{\kurz}[1]{\def\@kurz{#1}}
\newcommand{\@kurz}{???}


\newcommand*{\nr}[1]{\def\@nr{#1}}
\newcommand{\@nr}{???}

\newcommand*{\tutorium}[1]{\def\@tutorium{#1}}
\newcommand{\@tutorium}{???}


\newcommand*{\task}[1]{\def\@task{#1}}
\newcommand{\@task}{Aufgabe}

%---------------------------------------------%
%                 Student 1                   %
%---------------------------------------------%
\newcommand*{\name}[1]{\def\@name{#1}}
\newcommand{\@name}{???}

\newcommand*{\matrikel}[1]{\def\@matrikel{M: #1}}
\newcommand{\@matrikel}{M: ???}

\newcommand*{\ukennung}[1]{\def\@ukennung{, U: #1}}
\newcommand{\@ukennung}{}

%---------------------------------------------%
%                   Student 2                 %
%---------------------------------------------%
\newcommand*{\coname}[1]{\def\@coname{#1}\def\@comatrikel{M: ???} \def\@comatu{(\@comatrikel \@coukennung)}}
\newcommand{\@coname}{}
\newcommand{\@comatu}{}

\newcommand*{\comatrikel}[1]{\def\@comatrikel{M: #1}}
\newcommand{\@comatrikel}{}

\newcommand*{\coukennung}[1]{\def\@coukennung{, U: #1}}
\newcommand{\@coukennung}{}

%---------------------------------------------%
%                 Kopfzeile                   %
%---------------------------------------------%
\pagestyle{scrheadings}
\ihead[
    \begin{tabular}{ll}
    \@name   & \hspace{-0.3cm}(\@matrikel \@ukennung) \\
    \@coname & \hspace{-0.3cm}\@comatu
    \end{tabular}
]{
    \begin{tabular}{ll}
    \@name   \\
    \@coname
    \end{tabular}
}
\chead[]{\@kurz Ü\@nr}
\ohead[Tutorium: \@tutorium]{Tutorium: \@tutorium}

\RequirePackage{etoolbox}

\AtEndPreamble{
    \RequirePackage[unicode]{hyperref}
    \hypersetup{
    pdftitle    = {\@fach{}: Übungsblatt \@nr{}},
    pdfsubject  = {\@kurz{} ÜB},
    pdfauthor   = {\@name{}},
    pdfkeywords = {Studium, \@fach{}, \@kurz{}, Übungsblatt},
    colorlinks  = false,
}}

\renewcommand{\maketitle}{
    \thispagestyle{plain.scrheadings}
    ~\\\hspace{-.5cm}{\Large \textbf{\@fach}: Übungsblatt \@nr}
    \ifptable\@ptable\fi
}

%---------------------------------------------%
%               Andere Befehle                %
%---------------------------------------------%


%kein Einzug von neuen Absätzen
\setlength{\parindent}{0pt}

%Aufgabennummer wird hochgezählt für jede neu erstellte Aufgabe
\RequirePackage{totcount}
\regtotcounter{@anr}
\newcounter{@anr}[section]
\newenvironment{aufgabe}{\stepcounter{@anr} \paragraph{\@task\ \the@anr}~}{}
%\newenvironment{task}{\stepcounter{@anr} \paragraph{\@task\ \the@anr}~}{}

\newcommand{\@ptable}{
\edef\@phead{|c}
\newcounter{@foo}

% create header of table
\setcounter{@foo}{\value{@anr@totc}}
\loop
    \edef\@phead{\@phead |c}
\advance \c@@foo -1
\ifnum \c@@foo>0
\repeat
\edef\@phead{\@phead |}

\newwrite\tempfile
\immediate\openout\tempfile=rows.txt
\immediate\write\tempfile{\unexpanded{\hline}}

% create first line of table
\setcounter{@foo}{1}
\newcount\@anrr
\@anrr=\value{@anr@totc}

\advance \@anrr +1
\loop
    \immediate\write\tempfile{\the@foo &}
\advance \c@@foo +1
\ifnum \c@@foo<\@anrr
\repeat

\immediate\write\tempfile{\unexpanded{$\sum $\\\hline}}

% create second line of table
\setcounter{@foo}{\value{@anr@totc}}
\loop
    \immediate\write\tempfile{\unexpanded{~}&}
\advance \c@@foo -1
\ifnum \c@@foo>0
\repeat
\immediate\write\tempfile{\unexpanded{\quad\\\hline}}

\immediate\closeout\tempfile
\renewcommand{\arraystretch}{1.5}
\setlength{\tabcolsep}{15pt}
\unless\ifutable\vspace{-8ex}~\hfill\fi\begin{tabular}{\@phead}
    \csname @@input\endcsname rows.txt
\end{tabular}
\renewcommand{\arraystretch}{1}
\setlength{\tabcolsep}{6pt}
}


\makeatother
\endinput
