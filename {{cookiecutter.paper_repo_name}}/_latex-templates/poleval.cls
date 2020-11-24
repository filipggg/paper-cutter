{% raw %}
\ProvidesClass{poleval}[v.0.1]

\LoadClass[10pt,english]{book}


%% Czcionki itp.:
\usepackage[hidelinks]{hyperref}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}      % Typewriter.
\linespread{1.05}         % Palatino needs more leading (space between lines).
\usepackage{charter}
\usepackage[charter]{mathdesign}
\usepackage{textcomp}

%% Rozmiar papieru itp.:
\setlength\paperheight{238mm}   % b5: 250
\setlength\paperwidth{168mm}    % b5: 176
\usepackage[body={135mm,198mm},inner=18mm,top=12mm,twoside,includeheadfoot,headsep=8pt]{geometry}

% \usepackage{makeidx}
% \usepackage{boxhandler}

% %% Nagłówki, rozdziały itp.:
\usepackage{xifthen}
\usepackage{fancyhdr}
% \usepackage{bm}
\setlength{\headheight}{13.6pt}
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{%
\markboth{#1}{}}
\newcommand{\Thechapterauthor}{}
\newcommand{\chapterauthor}[2][]{\vspace{-.5em}%
  \thispagestyle{empty}%
  \ifthenelse{\isempty{#1}}%
  {\renewcommand{\Thechapterauthor}{#2}}%
  {\renewcommand{\Thechapterauthor}{#1}}%
%  {\addtocontents{toc}{#1}}
  {\bfseries\large\begin{flushleft}#2\end{flushleft}\vspace{3em}}}

\fancyhead[LE,RO]{\textnormal{\normalsize\thepage}}
\fancyfoot{}
\renewcommand{\headrulewidth}{0.6pt}

\usepackage[medium]{titlesec}
\titlelabel{\thetitle.\hspace{1em}}
\titleformat{\chapter}[block]
  {\normalfont}
  {}{0pt}{\titlerule\\[1ex]
    \bfseries\LARGE\raggedright}
\titlespacing*{\chapter}{0pt}{0pt}{2em}

% \makeatletter
% \renewcommand\part{%
%   \if@openright
%     \cleardoublepage
%   \else
%     \clearpage
%   \fi
%   \thispagestyle{empty}%
%   \if@twocolumn
%     \onecolumn
%     \@tempswatrue
%   \else
%     \@tempswafalse
%   \fi
%   \null\vfil
%   \secdef\@part\@spart}
% \makeatother


% \makeatletter
% \def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
%     \hbox{}
%     \thispagestyle{plain}
%     \newpage
%     \if@twocolumn\hbox{}\newpage\fi\fi\fi}
% \makeatother \clearpage{\pagestyle{plain}\cleardoublepage}

%% Inne rozmiary:
\setlength{\parindent}{8mm}
\setlength\parskip{\z@}         % stały parskip (z~mwbk.cls)
\renewcommand\footnoterule{%    % inna długość linii w~przypisach
  \kern-3\p@
  \hrule\@width 35mm
  \kern2.6\p@}

\newcommand{\captionfonts}{\small} % Different font in captions
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{{\captionfonts #1: #2}}%
  \ifdim \wd\@tempboxa >\hsize
    {\captionfonts #1: #2\par}
  \else
    \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}


% \newenvironment{betterquote}{\setlength{\leftmargini}{\parindent}\setlength{\rightmargin}{\parindent}\quote}{\endquote}

\newenvironment{abstract}{%
  \textbf{Abstract}\\[.75em]
}%

\newenvironment{keywords}{%
  \vspace{13pt}\textbf{Keywords}\\[.75em]
}%


%% Bibliografia i~odnośniki:
\usepackage{natbib}
\renewcommand\bibsection{\chapter*{\bibname}\addcontentsline{toc}{chapter}{\bibname}}
\bibpunct[:\,]{(}{)}{,}{}{}{,}
\setlength{\bibsep}{5pt plus 1pt}
\setlength{\bibhang}{0mm}


\renewcommand{\thesection}{\arabic{section}}

% %% Różności:

\usepackage{url}
\usepackage{microtype}
% \usepackage{ccicons}
\usepackage{amsmath}

\usepackage{booktabs}

% \usepackage{pdfpages}

\usepackage{enumitem} % Customize lists
\setlist{nolistsep, itemsep=5pt, topsep=2pt}
%\setlist[itemize]{leftmargin=\parindent}
%\setlist[enumerate]{leftmargin=\parindent}

\usepackage[font=small]{floatrow}
\usepackage[font=small]{caption}
\captionsetup{style=base}
\captionsetup[table]{position=below}
\captionsetup[figure]{position=below}
\captionsetup[table]{skip=10pt}
%\captionsetup{justification=raggedright,singlelinecheck=false}
\floatsetup[table]{capposition=top}
%\captionsetup{tablename=Tabela,labelsep=period}
\renewcommand{\thefigure}{\arabic{figure}}
\renewcommand{\thetable}{\arabic{table}}

\usepackage{multirow}
\usepackage[figuresright]{rotating}

% \usepackage[flushleft]{threeparttable}

% \def\timenow{\@tempcnta\time
%   \@tempcntb\@tempcnta
%   \divide\@tempcntb60
%   \ifnum10>\@tempcntb0\fi\number\@tempcntb
%   \multiply\@tempcntb60
%   \advance\@tempcnta-\@tempcntb
%   :\ifnum10>\@tempcnta0\fi\number\@tempcnta}


\usepackage{graphicx,array}

\usepackage[titles]{tocloft}
\setlength{\cftsecnumwidth}{2.3em}

\usepackage{titletoc,tocloft}
\setlength{\cftsubsecindent}{2cm}
\setlength{\cftsubsubsecindent}{4cm}
\dottedcontents{section}[1.5em]{}{1.3em}{.6em}

\renewcommand*\labelitemi{\textemdash}
\renewcommand*\labelitemii{\textemdash}
\renewcommand*\labelitemiii{\textemdash}
\renewcommand*\labelitemiv{\textemdash}

\renewcommand{\bibsection}{\section*{References}}


\addtolength{\headsep}{2mm}

\hbadness=5000
\vbadness=5000

\clubpenalty=10000
\widowpenalty=10000


\renewcommand*\l@chapter{\bigskip\@dottedtocline{0}{0em}{0em}}


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\fancyhead[RE]{\textnormal{\mbox{\small\Thechapterauthor}}}
\fancyhead[LO]{\textnormal{\small\leftmark}}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.9ex plus 0.5ex minus 0.2ex}

\newcommand{\nocontentsline}[3]{}
\newcommand{\tocless}[2]{\bgroup\let\addcontentsline=\nocontentsline#1{#2}\egroup}

\setcounter{tocdepth}{0}

\let\ps@plain\ps@empty





\endinput
{% endraw %}
