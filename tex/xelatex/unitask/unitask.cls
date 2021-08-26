\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{unitask}[2022/04/24 v1.0.2 simple university expercise sheet document class]

\LoadClassWithOptions{scrartcl}
\makeatletter

% option switches
\newif\ifptable
\newif\ifutable
\newif\ifetable
\newif\ifprefixtasknr

% options where to place the table of points
% top right - default
\DeclareOption{ptable}{\ptabletrue\utablefalse\etablefalse}
% under title
\DeclareOption{utable}{\ptabletrue\utabletrue\etablefalse}
% end of document
\DeclareOption{etable}{\ptablefalse\utablefalse\etabletrue}
% no table
\DeclareOption{ntable}{\ptablefalse\utabletrue\etablefalse \newcommand{\ptable}\@ptable}

% add first letter of the task name to number of the tas k in the table of points
\DeclareOption{prefixtasknr}{\prefixtasknrtrue}
\DeclareOption{simpletasknr}{\prefixtasknrfalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}

\ExecuteOptions{ptable,simpletasknr}
\ProcessOptions\relax

% import packages
\RequirePackage[plainheadsepline]{scrlayer-scrpage}
\RequirePackage{xunicode}
\RequirePackage{xltxtra}
\RequirePackage{enumerate}
\RequirePackage{soul}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\usepackage{xstring}
\RequirePackage{totcount}
\RequirePackage{xcolor}

\RequirePackage{fontspec}
\setmainfont{Latin Modern Roman}
\renewcommand{\familydefault}{\sfdefault}

\newcommand{\@missingdecleration}{\color{red}{???}} % highlights missing mandatory information

%---------------------------------------------%
%               common Configuration          %
%---------------------------------------------%

\newcommand*{\fach}[1]{\def\@fach{#1}}
\newcommand*{\course}[1]{\fach{#1}}
\newcommand{\@fach}{\@missingdecleration}

\newcommand*{\kurz}[1]{\def\@kurz{#1}}
\newcommand*{\short}[1]{\kurz{#1}}
\newcommand{\@kurz}{\@missingdecleration}


\newcommand*{\nr}[1]{\def\@nr{#1}}
\newcommand{\@nr}{\@missingdecleration}


\newcommand*{\tutorium}[1]{\def\@tutorium{#1}}
%\newcommand{\@tutorium}{\@missingdecleration}

\newcommand*{\dtask}[1]{\def\@task{#1}}
\newcommand{\@task}{Aufgabe} % todo translate with babel/polyglossia

%---------------------------------------------%
%                 Student 1                   %
%---------------------------------------------%
\newcommand*{\name}[1]{\def\@name{#1}}
\newcommand{\@name}{\@missingdecleration}

\newcommand*{\matrikel}[1]{\def\@matrikel{M: #1}}
\newcommand{\@matrikel}{M: \@missingdecleration}

\newcommand*{\ukennung}[1]{\def\@ukennung{, U: #1}}
\newcommand{\@ukennung}{}

%---------------------------------------------%
%                   Student 2                 %
%---------------------------------------------%
\newcommand*{\coname}[1]{\def\@coname{#1}\def\@comatrikel{M: \@missingdecleration} \def\@comatu{(\@comatrikel \@coukennung)}}
\newcommand{\@coname}{}
\newcommand{\@comatu}{}

\newcommand*{\comatrikel}[1]{\def\@comatrikel{M: #1}}
\newcommand{\@comatrikel}{}

\newcommand*{\coukennung}[1]{\def\@coukennung{, U: #1}}
\newcommand{\@coukennung}{}

%---------------------------------------------%
%                 HEADING                     %
%---------------------------------------------%
\pagestyle{scrheadings}

%\KOMAoption{plainheadsepline}{on}

\ihead[
    \begin{tabular}{ll}
        \@name   & \hspace{-0.3cm}(\@matrikel \@ukennung) \\
        \@coname & \hspace{-0.3cm}\@comatu
    \end{tabular}
]{
    \begin{tabular}{l}
        \@name \\
        \@coname
    \end{tabular}
}

\AtBeginDocument{
    \ifdef{\@tutorium}{
        \chead[]{\@kurz\ Ü\@nr}
        \ohead[Tutorium: \@tutorium]{Tutorium: \@tutorium}
    }{
        \ohead[]{\@kurz\ Ü\@nr}
        \chead[]{}
    }
}


\AtEndPreamble{
    \RequirePackage[unicode]{hyperref}
    \hypersetup{
        pdftitle    = {\@fach{}: Übungsblatt \@nr{}},
        pdfsubject  = {\@kurz{} ÜB},
        pdfauthor   = {\@name{}},
        pdfkeywords = {Studium, \@fach{}, \@kurz{}, Übungsblatt},
        colorlinks  = false,
    }
	\RequirePackage[nameinlink]{cleveref}
    
    % change operatorfont to sans-serif as well
    \@ifpackageloaded{unicode-math}{\setoperatorfont\mathsf}{}
}

\renewcommand{\maketitle}
{
    \thispagestyle{plain.scrheadings}
    ~\\\hspace{-.5cm}{\Large \underline{\textbf{\@fach}}: Übungsblatt \@nr}
    \ifptable\@ptable\fi

}

\AtEndDocument{
    \ifetable\vspace{1cm}
    \begin{table}[h]
        \centering
        \@ptable
    \end{table}
    \fi
    % always gen table AFTER all tasks have been created
    \@genptable
}


%---------------------------------------------%
%                  MISC                       %
%---------------------------------------------%
\KOMAoptions{draft=false} % disable weird symbols if in draft mode

% no parindent
\setlength{\parindent}{0pt}

%  COUNTERS
% ==========
\newcounter{@tasknr} % sum of tasks
\regtotcounter{@tasknr}
\newcounter{@c@tasknr} % the current task number we are working on

\newcounter{@taskpoints} % sum of task points
\regtotcounter{@taskpoints}


%  HELPER COMMANDS
% =================

% minipage for displaying the point fractions
\newcommand{\@taskpointsminipage}[1]{%
	\unexpanded{%
	\hfil\scalebox{.5}{%
		\begin{minipage}[b][1.6cm]{.2cm}%
			⁄#1%
		\end{minipage}%
	}%
}}

\NewDocumentEnvironment{aufgabe}
{o O{\@task} o o}% Syntax: [points][custom name][custom number][custom prefix]
{%
	\StrChar{#2}{1}[\@taskprefix]
	\stepcounter{@tasknr}%
	\IfValueT{#1}{% save task points
			\addtocounter{@taskpoints}{#1}
			\global\csdef{task\the@tasknr-pt}{\@taskpointsminipage{#1}}%
	}%
	\global\csedef{task\the@tasknr-ref}{% save task ref in table of point
		\ifprefixtasknr\IfValueTF{#4}{#4}{\@taskprefix}\fi\IfValueTF{#3}{#3}{\arabic{@tasknr}}%
	}%
	\paragraph{{\large #2\ \IfValueTF{#3}{#3}{\arabic{@tasknr}}}~}
}{}

%%% write ptable.tex so in the next compile we can access the saved tasks
\newcommand{\@genptable}{
	% open the ptable.tex file
	\newwrite\tempfile
	\immediate\openout\tempfile=ptable.tex
	
	\immediate\write\tempfile{\unexpanded{\hline}}
	
	% create first line of table
	\setcounter{@c@tasknr}{1}
	
	\loop
	\immediate\write\tempfile{\csuse{task\the@c@tasknr-ref} &}
	\stepcounter{@c@tasknr}
	\ifnum \value{@c@tasknr}<\numexpr\totvalue{@tasknr}+1\relax
	\repeat
	
	\immediate\write\tempfile{\unexpanded{$\sum$\\\hline}}
	
	% create second line of table
	\setcounter{@c@tasknr}{1}
	\loop
	\immediate\write\tempfile{\csuse{task\the@c@tasknr-pt}&}
	\stepcounter{@c@tasknr}
	\ifnum \value{@c@tasknr}<\numexpr\totvalue{@tasknr}+1\relax
	\repeat
	\immediate\write\tempfile{\@taskpointsminipage{\total{@taskpoints}}} 
	\immediate\write\tempfile{\unexpanded{\\\hline}}
	
	\immediate\closeout\tempfile
}

\newcommand{\@ptable}{
	% create header of table
	\def\@phead{}
	\setcounter{@c@tasknr}{\totvalue{@tasknr}}
	\loop
	\edef\@phead{\@phead |c}
	\addtocounter{@c@tasknr}{-1}
	\ifnum \value{@c@tasknr}>0
	\repeat
	\edef\@phead{\@phead ||c|}
	
    \renewcommand{\arraystretch}{1.4}
    \setlength{\tabcolsep}{15pt}

    % place ptable in the top right, unless utable choosen
    \ifptable\unless\ifutable
    	\vspace{-7ex}~
    	\begin{flushright}
    \fi\fi
	
	\ifutable
	\vspace{0.25em}
	\fi
        \IfFileExists{ptable.tex}{%
        	\begin{tabular}{\@phead}
        		\csname @@input\endcsname ptable.tex
        	\end{tabular}
        }%
        {\fbox{\color{red} ! Recompile to see table of points !}}

    % close environment
    \ifptable\unless\ifutable
    	\end{flushright}
    \fi\fi

    \renewcommand{\arraystretch}{1}
    \setlength{\tabcolsep}{6pt}
}


\makeatother
\endinput
