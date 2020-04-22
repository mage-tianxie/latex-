\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\ProvidesClass{cjc}[2020/04/19 v0.2 A template framework for Chinese journals]

% 报错和警告
\newcommand\class@error[1]{%
  \ClassError{cjc}{#1}{}%
}
\newcommand\class@warning[1]{%
  \ClassWaring{cjc}{#1}%
}

% 检查 \LaTeXe{} kernel 版本
\@ifl@t@r\fmtversion{2017/04/15}{}{
  \class@error{%
    TeX Live 2017 or later version is required to compile this document%
  }
}

% 检查编译引擎，要求使用 XeLaTeX。
\RequirePackage{iftex}
\ifXeTeX\else
  \class@error{XeLaTeX is required to compile this document}
\fi

% 提供 key-value 接口。
\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}

\kv@set@family@handler{class@key}{%
  \@namedef{class@#1@@name}{#1}%
  \def\class@@default{}%
  \def\class@@choices{}%
  \kv@define@key{class@value}{name}{%
    \@namedef{class@#1@@name}{##1}%
  }%
  \@namedef{class@#1@@check}{}%
  \@namedef{class@#1@@code}{}%
  \kv@define@key{class@value}{choices}{%
    \def\class@@choices{##1}%
    \@namedef{class@#1@@reset}{}%
    \@namedef{class@#1@@check}{%
      \@ifundefined{%
        ifclass@\@nameuse{class@#1@@name}@\@nameuse{class@\@nameuse{class@#1@@name}}%
      }{%
        \class@error{Invalid value "#1 = \@nameuse{class@\@nameuse{class@#1@@name}}"}%
      }%
      \@nameuse{class@#1@@reset}%
      \@nameuse{class@\@nameuse{class@#1@@name}@\@nameuse{class@\@nameuse{class@#1@@name}}true}%
    }%
  }%
  \kv@define@key{class@value}{default}{%
    \def\class@@default{##1}%
  }%
  \kvsetkeys{class@value}{#2}%
  \@namedef{class@\@nameuse{class@#1@@name}}{}%
  \kv@set@family@handler{class@choice}{%
    \ifx\class@@default\@empty
      \def\class@@default{##1}%
    \fi
    \expandafter\newif\csname ifclass@\@nameuse{class@#1@@name}@##1\endcsname
    \expandafter\g@addto@macro\csname class@#1@@reset\endcsname{%
      \@nameuse{class@\@nameuse{class@#1@@name}@##1false}%
    }%
  }%
  \kvsetkeys@expandafter{class@choice}{\class@@choices}%
  \expandafter\let\csname class@\@nameuse{class@#1@@name}\endcsname\class@@default
  \expandafter\ifx\csname class@\@nameuse{class@#1@@name}\endcsname\@empty\else
    \@nameuse{class@#1@@check}%
  \fi
  \kv@define@key{class}{#1}{%
    \@namedef{class@\@nameuse{class@#1@@name}}{##1}%
    \@nameuse{class@#1@@check}%
    \@nameuse{class@#1@@code}%
  }%
}

\newcommand\class@define@key[1]{%
  \kvsetkeys{class@key}{#1}%
}
\newcommand\classsetup[1]{%
  \kvsetkeys{class}{#1}%
}
\newcommand\class@option@hook[2]{%
  \expandafter\g@addto@macro\csname class@#1@@code\endcsname{#2}%
}


\class@define@key{
  language = {
    choices = {
      chinese,
      english,
    },
    default = chinese,
  },
  fontset = {
    choices = {
      windows,
      mac,
      ubuntu,
      fandol,
      none,
    },
    default = none,
  },
}

% 使用 \pkg{kvoptions} 提供的 key-value 接口，
\SetupKeyvalOptions{
  family  = class,
  prefix  = class@,
  setkeys = \kvsetkeys,
}

\PassOptionsToClass{UTF8,a4paper,scheme=plain,fontset=none,zihao=5,twoside,twocolumn}{ctexart}
\PassOptionsToPackage{quiet}{xeCJK}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessKeyvalOptions*

% 载入 \cls{ctexart} 文档类，要求为 2.4.9 或更高的版本。
\LoadClass{ctexart}[2017/04/01]

\RequirePackage{geometry}
\RequirePackage{fontspec}[2017/03/31]
\RequirePackage{amsmath}
\RequirePackage{unicode-math}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{amsthm}
\RequirePackage{caption}
\RequirePackage[sort&compress]{natbib}
\RequirePackage{url}
\RequirePackage{etoolbox}

% 对冲突的宏包报错。
\RequirePackage{filehook}
\newcommand\class@package@conflict[2]{
  \AtBeginOfPackageFile*{#2}{
    \class@error{The "#2" package is incompatible with required "#1"}
  }
}
\class@package@conflict{natbib}{cite}
\class@package@conflict{unicode-math}{amscd}
\class@package@conflict{unicode-math}{amsfonts}
\class@package@conflict{unicode-math}{amssymb}
\class@package@conflict{unicode-math}{bbm}
\class@package@conflict{unicode-math}{bm}
\class@package@conflict{unicode-math}{eucal}
\class@package@conflict{unicode-math}{eufrak}
\class@package@conflict{unicode-math}{mathrsfs}

% 字体

\class@define@key{
  font = {
    choices = {
      times,
      termes,
      xits,
      libertinus,
      lm,
      auto,
      none,
    },
    default = auto,
  },
  cjk-font = {
    name = cjk@font,
    choices = {
      windows,
      mac,
      noto,
      fandol,
      auto,
      none,
    },
    default = auto,
  },
  math-font = {
    name = math@font,
    choices = {
      xits,
      stix,
      libertinus,
      lm,
      none,
    },
    default = xits,
  },
}

% 处理 \opt{fontset}
\ifclass@fontset@mac
  \classsetup{
    font     = times,
    cjk-font = mac,
  }
\else
  \ifclass@fontset@windows
    \classsetup{
      font     = times,
      cjk-font = windows,
    }
  \else
    \ifclass@fontset@fandol
      \classsetup{
        font     = xits,
        cjk-font = fandol,
      }
    \else
      \ifclass@fontset@ubuntu
        \classsetup{
          font     = xits,
          cjk-font = noto,
        }
      \fi
    \fi
  \fi
\fi

% 检测系统
\class@define@key{
  system = {
    choices = {
      auto,
      mac,
      unix,
      windows,
    },
    default = auto,
  },
}
\ifclass@system@auto
  \IfFileExists{/System/Library/Fonts/Menlo.ttc}{
    \classsetup{system = mac}
  }{
    \IfFileExists{/dev/null}{
      \IfFileExists{null:}{
        \classsetup{system = windows}
      }{
        \classsetup{system = unix}
      }
    }{
      \classsetup{system = windows}
    }
  }
\fi

% XITS 字体于 2018-10-03 更改了字体的文件名，所以需要判断。
% 原文件名为 \file{xits-regular.otf}、\file{xits-math.otf} 等，
% 后改为 \file{XITS-Regular.otf}、\file{XITSMath-Regular.otf} 等。
\let\class@font@family@xits\@empty
\newcommand\class@set@xits@names{%
  \ifx\class@font@family@xits\@empty
    \IfFontExistsTF{XITSMath-Regular.otf}{%
      \gdef\class@font@family@xits{XITS}%
      \gdef\class@font@style@xits@rm{Regular}%
      \gdef\class@font@style@xits@bf{Bold}%
      \gdef\class@font@style@xits@it{Italic}%
      \gdef\class@font@style@xits@bfit{BoldItalic}%
      \gdef\class@font@name@xits@math@rm{XITSMath-Regular}%
      \gdef\class@font@name@xits@math@bf{XITSMath-Bold}%
    }{%
      \gdef\class@font@family@xits{xits}%
      \gdef\class@font@style@xits@rm{regular}%
      \gdef\class@font@style@xits@bf{bold}%
      \gdef\class@font@style@xits@it{italic}%
      \gdef\class@font@style@xits@bfit{bolditalic}%
      \gdef\class@font@name@xits@math@rm{xits-math}%
      \gdef\class@font@name@xits@math@bf{xits-mathbold}%
    }%
  \fi
}

% Libertinus 字体同样。
\let\class@font@family@libertinus\@empty
\newcommand\class@set@libertinus@names{%
  \ifx\class@font@family@libertinus\@empty
    \IfFontExistsTF{LibertinusSerif-Regular.otf}{%
      \gdef\class@font@family@libertinus@serif{LibertinusSerif}%
      \gdef\class@font@family@libertinus@sans{LibertinusSans}%
      \gdef\class@font@name@libertinus@math{LibertinusMath-Regular}%
      \gdef\class@font@style@libertinus@rm{Regular}%
      \gdef\class@font@style@libertinus@bf{Bold}%
      \gdef\class@font@style@libertinus@it{Italic}%
      \gdef\class@font@style@libertinus@bfit{BoldItalic}%
    }{%
      \gdef\class@font@family@libertinus@serif{libertinusserif}%
      \gdef\class@font@family@libertinus@sans{libertinussans}%
      \gdef\class@font@name@libertinus@math{libertinusmath-regular}%
      \gdef\class@font@style@libertinus@rm{regular}%
      \gdef\class@font@style@libertinus@bf{bold}%
      \gdef\class@font@style@libertinus@it{italic}%
      \gdef\class@font@style@libertinus@bfit{bolditalic}%
    }%
  \fi
}

% 西文字体
\ifclass@font@auto
  \ifclass@system@unix
    \classsetup{font=xits}
  \else
    \classsetup{font=times}
  \fi
\fi
\newcommand\class@load@font@times{%
  \setmainfont{Times New Roman}%
  \setsansfont{Arial}[Scale = MatchLowercase]%
  \ifclass@system@mac
    \setmonofont{Menlo}[Scale = MatchLowercase]%
  \else
    \setmonofont{Courier New}[Scale = MatchLowercase]%
  \fi
}
\newcommand\class@load@font@termes{%
  \setmainfont{texgyretermes}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \class@load@texgyre@sans@mono
}
\newcommand\class@load@texgyre@sans@mono{%
  \setsansfont{texgyreheros}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
    Scale          = MatchLowercase,
  ]%
  \setmonofont{texgyrecursor}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
    Scale          = MatchLowercase,
  ]%
}
\newcommand\class@load@font@xits{%
  \class@set@xits@names
  \setmainfont{\class@font@family@xits}[
    Extension      = .otf,
    UprightFont    = *-\class@font@style@xits@rm,
    BoldFont       = *-\class@font@style@xits@bf,
    ItalicFont     = *-\class@font@style@xits@it,
    BoldItalicFont = *-\class@font@style@xits@bfit,
  ]%
  \class@load@texgyre@sans@mono
}
\newcommand\class@load@font@libertinus{%
  \class@set@libertinus@names
  \setmainfont{\class@font@family@libertinus@serif}[
    Extension      = .otf,
    UprightFont    = *-\class@font@style@libertinus@rm,
    BoldFont       = *-\class@font@style@libertinus@bf,
    ItalicFont     = *-\class@font@style@libertinus@it,
    BoldItalicFont = *-\class@font@style@libertinus@bfit,
  ]%
  \setsansfont{\class@font@family@libertinus@sans}[
    Extension      = .otf,
    UprightFont    = *-\class@font@style@libertinus@rm,
    BoldFont       = *-\class@font@style@libertinus@bf,
    ItalicFont     = *-\class@font@style@libertinus@it,
    Scale          = MatchLowercase,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
    Scale          = MatchLowercase,
  ]%
}
\newcommand\class@load@font@lm{%
  \setmainfont{lmroman10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setsansfont{lmsans10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}
\newcommand\class@load@font{%
  \@nameuse{class@load@font@\class@font}%
}
\class@load@font
\class@option@hook{font}{\class@load@font}

% 中文字体
\ifclass@cjk@font@auto
  \ifclass@system@mac
    \classsetup{cjk-font = mac}
  \else
    \ifclass@system@windows
      \classsetup{cjk-font = windows}
    \else
      \IfFontExistsTF{Noto Serif CJK SC}{
        \classsetup{cjk-font = noto}
      }{
        \classsetup{cjk-font = fandol}
      }
    \fi
  \fi
\fi
\newcommand\class@load@cjk@font@windows{%
  \xeCJKsetup{EmboldenFactor=2}
  \setCJKmainfont{SimSun}[
    AutoFakeBold = true,
    ItalicFont   = KaiTi,
  ]%
  \setCJKsansfont{SimHei}[AutoFakeBold]%
  \setCJKmonofont{FangSong}%
  \setCJKfamilyfont{zhsong}{SimSun}[AutoFakeBold]%
  \setCJKfamilyfont{zhhei}{SimHei}[AutoFakeBold]%
  \setCJKfamilyfont{zhkai}{KaiTi}%
  \setCJKfamilyfont{zhfs}{FangSong}%
}
\newcommand\class@load@cjk@font@mac{%
  \setCJKmainfont{Songti SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = Kaiti SC,
    BoldItalicFont = Kaiti SC Bold,
  ]%
  \setCJKsansfont{Heiti SC}[BoldFont=* Medium]%
  \setCJKmonofont{STFangsong}
  \setCJKfamilyfont{zhsong}{Songti SC}[
    UprightFont = * Light,
      BoldFont  = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Heiti SC}[
    UprightFont = * Light,
    BoldFont    = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{STFangsong}%
  \setCJKfamilyfont{zhkai}{Kaiti SC}[BoldFont = * Bold]%
  \setCJKfamilyfont{zhli}{Baoli SC}%
  \setCJKfamilyfont{zhyuan}{Yuanyi SC}[
    UprightFont = * Light,
    BoldFont    = * Bold,
  ]%
  \xeCJKsetwidth{‘’“”}{1em}%
}

% 注意 Noto CJK 的 regular 字重名字不带“Regular”。
\newcommand\class@load@cjk@font@noto{%
  \setCJKmainfont{Noto Serif CJK SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = FandolKai-Regular,
    ItalicFeatures = {Extension = .otf},
  ]%
  \setCJKsansfont{Noto Sans CJK SC}[
    BoldFont    = * Medium,
  ]%
  \setCJKmonofont{Noto Sans Mono CJK SC}%
  \setCJKfamilyfont{zhsong}{Noto Serif CJK SC}[
    UprightFont = * Light,
    UprightFont = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Noto Sans CJK SC}[
    BoldFont    = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
}
\newcommand\class@load@cjk@font@fandol{%
  \setCJKmainfont{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
    ItalicFont  = FandolKai-Regular,
  ]%
  \setCJKsansfont{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKmonofont{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhsong}{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhhei}{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
}
\ifclass@cjk@font@none\else
  \providecommand\songti{\CJKfamily{zhsong}}
  \providecommand\heiti{\CJKfamily{zhhei}}
  \providecommand\fangsong{\CJKfamily{zhfs}}
  \providecommand\kaishu{\CJKfamily{zhkai}}
\fi
\newcommand\class@load@cjk@font{%
  \@nameuse{class@load@cjk@font@\class@cjk@font}%
}
\class@load@cjk@font
\class@option@hook{cjk-font}{\class@load@cjk@font}

% 使用 \pkg{unicode-math} 配置数学字体。
\unimathsetup{
  math-style = ISO,
  bold-style = ISO,
  nabla      = upright,
  partial    = upright,
}

\newcommand\class@load@math@font@xits{%
  \class@set@xits@names
  \setmathfont{\class@font@name@xits@math@rm}[
    Extension    = .otf,
    BoldFont     = \class@font@name@xits@math@bf,
    StylisticSet = 8,
  ]%
  \setmathfont{\class@font@name@xits@math@rm}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {cal,bfcal},
  ]%
}
\newcommand\class@load@math@font@stix{%
  \setmathfont{STIX2Math}[
    Extension    = .otf,
    StylisticSet = 8,
  ]%
  \setmathfont{STIX2Math}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {cal,bfcal},
  ]%
}
\newcommand\class@load@math@font@libertinus{%
  \class@set@libertinus@names
  \setmathfont{\class@font@name@libertinus@math .otf}%
}
\newcommand\class@load@math@font@lm{%
  \setmathfont{latinmodern-math.otf}%
}
\newcommand\class@load@math@font{%
  \csname class@load@math@font@\class@math@font\endcsname
}
\class@load@math@font
\class@option@hook{math-font}{\class@load@math@font}


% 字号

\linespread{1.25}\selectfont


% \subsection{处理语言}

\newcommand\class@set@names{%
  \ifclass@language@chinese
    \ctexset{
      appendixname = {附录},
      contentsname = {目录},
      figurename   = {图},
      tablename    = {表},
      bibname      = {参考文献},
      indexname    = {索引},
      autoindent   = 2,
    }%
  \else
    \ctexset{
      appendixname = {Appendix},
      contentsname = {Contents},
      figurename   = {Fig.},
      tablename    = {Table},
      bibname      = {References},
      indexname    = {Index},
      autoindent   = 2,
    }%
  \fi
}
\class@set@names
\class@option@hook{language}{\class@set@names}

% 由于 Unicode 的一些标点符号是中西文混用的：
% 所以要根据语言设置正确的字体。
\newcommand\class@setchinese{%
  \xeCJKResetPunctClass
}
\newcommand\class@setenglish{%
  \xeCJKDeclareCharClass{HalfLeft}{"2018, "201C}%
  \xeCJKDeclareCharClass{HalfRight}{%
    "00B7, "2019, "201D, "2013, "2014, "2025, "2026, "2E3A%
  }%
}
\newcommand\class@setdefaultlanguage{%
  \ifclass@language@chinese
    \class@setchinese
  \else
    \class@setenglish
  \fi
}


% 纸张和页面

% 使用 \pkg{geometry} 宏包设置纸张和页面。
% 纸张：A4；
% 页面设置：上、下 2.6 cm，左、右 2 cm，页眉 1.7 cm，页脚 1.7 cm。

\geometry{
  paper      = a4paper,
  vmargin    = 2.6cm,
  hmargin    = 2cm,
  headheight = 0.75cm,
  headsep    = 0.15cm,
  twocolumn  = true,
  columnsep  = 0.75cm,
}


% 页眉

\AtBeginDocument{
  \setcounter{page}{\class@page}
}

% 使用 \pkg{fancy} 需要先调用 |\pagestyle{fancy}| 再修改 \cs{sectionmark}。
\pagestyle{fancy}
\let\sectionmark\@gobble
\renewcommand\headrulewidth{0.4\p@}

\newcommand\class@hf@font{\fontsize{9bp}{15bp}\linespread{1}\selectfont}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyhead[LO]{\class@hf@font \class@number{} 期}%
  \fancyhead[CO]{\class@hf@font \class@format@short@names ：\class@title}%
  \fancyhead[RO,LE]{\class@hf@font\thepage}%
  \fancyhead[CE]{\class@hf@font 计算机学报}%
  \fancyhead[RE]{\class@hf@font \class@date@zh@year{\class@publish@date}}%
}
\pagestyle{plain}

\newcommand\class@format@short@names{%
  \let\class@@tmp\@empty
  \let\class@@et@al\@empty
  \kv@set@family@handler{class@authors}{%
    \kvsetkeys{class@author}{##2}%
    \ifx\class@@tmp\@empty
      \let\class@@tmp\class@@name@main
      \class@@name@main
    \else
      \ifx\class@@et@al\@empty
        \let\class@@et@al\class@@name@main
        \ifclass@language@chinese
          等%
        \else
          \space\textit{et al}%
        \fi
      \fi
    \fi
  }%
  \kvsetkeys@expandafter{class@authors}{\class@authors}%
}

\fancypagestyle{title}{%
  \fancyhf{}%
  \fancyhead[L]{%
    \class@hf@font
    第 \class@volume{} 卷\quad 第 \class@number{} 期 \\
    \class@date@zh@short{\class@publish@date}%
  }%
  \fancyhead[C]{%
    \class@hf@font
    计算机学报\\
    CHINESE JOURNAL OF COMPUTERS%
  }%
  \fancyhead[R]{%
    \class@hf@font
    Vol. \class@volume\quad No. \class@number\\
    \class@date@en@short{\class@publish@date}%
  }%
}

\newcommand\class@format@date[2]{%
  \edef\class@@date{#2}%
  \def\class@@process@date##1-##2-##3\@nil{%
    #1{##1}{##2}{##3}%
  }%
  \expandafter\class@@process@date\class@@date\@nil
}
\newcommand\class@date@zh@short[1]{%
  \def\class@@format##1##2##3{%
    ##1 年 \number##2 月%
  }%
  \class@format@date{\class@@format}{#1}%
}
\newcommand\class@date@zh@year[1]{%
  \def\class@@format##1##2##3{##1 年}%
  \class@format@date{\class@@format}{#1}%
}
\newcommand\class@short@month[1]{%
  \ifcase\number#1\relax
    XXX.\or
    Jan.\or Feb.\or Mar.\or Apr.\or May\or Jun.\or
    Jul.\or Aug.\or Sep.\or Oct.\or Nov.\or Dec.%
  \fi
}%
\newcommand\class@date@en[1]{%
  \def\class@@format##1##2##3{%
    ##3 \class@short@month{##2} ##1%
  }%
  \class@format@date{\class@@format}{#1}%
}

\newcommand\class@date@en@short[1]{%
  \def\class@@format##1##2##3{%
    \class@short@month{##2} ##1%
  }%
  \class@format@date{\class@@format}{#1}%
}


% \subsection{标题}

\class@define@key{
  title = {
    default = {标题},
  },
  title* = {
    default = {Title},
    name    = title@alt,
  },
  short-title = {
    name = short@title,
  },
  authors = {},
  affiliations = {},
  abstract = {
    default = {摘要内容},
  },
  abstract* = {
    default = {Abstract content},
    name    = abstract@alt,
  },
  keywords = {},
  keywords* = {
    name    = keywords@alt,
  },
  clc = {
    default = {TP391},
  },
  doi = {
    default = {10.11897/SP.J.1016.01.\the\year.\class@five@digits\thepage},
  },
  received-date = {
    name = received@date,
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  revised-date = {
    name = revised@date,
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  grants  = {},
  grants* = {
    name = grants@alt,
  },
  publish-date = {
    name = publish@date,
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  volume = {
    default = {43},
  },
  number = {
    default = {1},
  },
  page = {
    default = {1},
  },
}

% 主标题
\renewcommand\maketitle{\par%
  \begingroup
    % \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    % \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \let\@makefnmark\relax
    % \long\def\@makefntext##1{\parindent 1em\noindent
    %         \hb@xt@1.8em{%
    %             \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \long\def\@makefntext##1{##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    % \thispagestyle{plain}\@thanks
    \thispagestyle{title}%
    \class@title@footnote@main
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\maketitlealt
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}

% 定义命令用于录入信息。
\def\@maketitle{%
  \newpage
  \null
  \class@make@title@zh
  \class@make@title@en
  \vskip 18bp%
}

\def\class@make@title@zh{%
  \classsetup{language = chinese}%
  \vspace*{20bp}%
  \begingroup
    \centering
    \begingroup
      \heiti\zihao{2}\class@title\par
    \endgroup
    \vskip 10.5bp%
    \begingroup
      \fangsong\zihao{3}\class@format@authors{main}\par
    \endgroup
    \vskip 5.7bp%
    \begingroup
      \zihao{6}\class@format@affiliations{main}\par
    \endgroup
  \endgroup
  \vspace*{7.8bp}%
  \begingroup
    \zihao{-5}%
    {\heiti 摘\quad 要}\quad\class@abstract\par
    \begingroup
      \hangindent=4em%
      关键词\quad
      \class@clist@use{\class@keywords}{；}\par
    \endgroup
    {\heiti 中图法分类号}\quad\class@clc\hspace{3em}%
    {\heiti DOI 号}\quad\doi{\class@doi}\par
  \endgroup
}

\newcommand\class@five@digits[1]{%
  \ifnum#1<10
    0000%
  \else
    \ifnum#1<100
      000%
    \else
      \ifnum#1<1000
        00%
      \else
        \ifnum#1<10000
          0%
        \fi
      \fi
    \fi
  \fi
  \number#1%
}

\def\class@make@title@en{%
  \classsetup{language = english}%
  \vspace*{12bp}%
  \begingroup
    \centering
    \begingroup
      \bfseries\zihao{4}\class@title@alt\par
    \endgroup
    \vskip 11bp%
    \begingroup
      \zihao{5}\class@format@authors{alt}\par
    \endgroup
    \vskip 9bp%
    \begingroup
      \zihao{6}\class@format@affiliations{alt}\par
    \endgroup
  \endgroup
  \vspace{5bp}%
  \begingroup
    \zihao{-5}%
    \textbf{Abstract}\quad\class@abstract@alt\par
    \begingroup
      \hangindent=6.32em%
      \textbf{Key words}\quad
      \class@clist@use{\class@keywords@alt}{; }\par
    \endgroup
  \endgroup
}

% 处理中文姓名格式
\newbox\class@@box
\newcommand\class@format@name@zh[1]{%
  \sbox\class@@box{#1}%
  \ifdim\wd\class@@box<2.1em\relax
    \ifdim\wd\class@@box>1.5em\relax
      \begingroup
        \def\CJKglue{\hskip 0pt plus 2filll}%
        \makebox[3em][l]{#1}%
      \endgroup
    \else
      #1%
    \fi
  \else
    #1%
  \fi
}

\newcommand\class@format@name@en[1]{#1}

\newcommand\class@clist@use[2]{%
  \begingroup
    \def\class@@tmp{}%
    \def\class@clist@processor##1{%
      \ifx\class@@tmp\@empty
        \def\class@@tmp{#2}%
      \else
        #2%
      \fi
      ##1%
    }%
    \expandafter\comma@parse\expandafter{#1}{\class@clist@processor}%
  \endgroup
}

\newcommand\class@valid@affiliations{}
\def\class@@tmp@affil{}
\newcounter{class@affil@count}
\kv@set@family@handler{class@affil@number}{%
  \expandafter\ifx\csname class@affil@number@#1\endcsname\relax
    \stepcounter{class@affil@count}%
    \expandafter\xdef\csname class@affil@number@#1\endcsname{%
      \the\c@class@affil@count
    }%
    \g@addto@macro\class@valid@affiliations{#1,}%
  \fi
  \ifx\class@@tmp@affil\@empty
    \def\class@@tmp@affil{1}%
  \else
    ,%
  \fi
  \csname class@affil@number@#1\endcsname)%
}

\newcommand\class@format@affil@numbers[1]{%
  % \kvsetkeys@expandafter{class@affil@number}{#1}%
  \def\class@@tmp@affil{}%
  \kvsetkeys@expandafter{class@affil@number}{#1}%
}

\newif\ifclass@@corresponding
\kv@define@key{class@author}{name}{\def\class@@name@main{#1}}
\kv@define@key{class@author}{name*}{\def\class@@name@alt{#1}}
\kv@define@key{class@author}{affiliations}{\def\class@@affils{#1}}
\kv@define@key{class@author}{biography}{\def\class@@biography{#1}}
\kv@define@key{class@author}{biography*}{\def\class@@biography@alt{#1}}
\kv@define@key{class@author}{email}{\def\class@@email{#1}}
\kv@define@key{class@author}{corresponding}[false]{%
  \@nameuse{class@@corresponding#1}%
}
\kv@define@key{class@author}{phone-number}{\def\class@@phone{#1}}

% 选择 main 或者 alternative
\newcommand\class@format@authors[1]{%
  \let\class@@tmp\@empty
  \kv@set@family@handler{class@authors}{%
    \kvsetkeys{class@author}{##2}%
    \ifx\class@@tmp\@empty
      \def\class@@tmp{1}%
    \else
      \quad
    \fi
    \ifclass@language@chinese
      \scalebox{0.66}[1]{%
        \class@format@name@zh{\@nameuse{class@@name@#1}}%
        \textsuperscript{\class@format@affil@numbers{\class@@affils}}%
      }%
    \else
      \class@format@name@en{\@nameuse{class@@name@#1}}%
      \textsuperscript{\class@format@affil@numbers{\class@@affils}}%
    \fi
  }%
  \kvsetkeys@expandafter{class@authors}{\class@authors}%
}

\kv@define@key{class@affiliation}{name}{\def\class@@affil@main{#1}}
\kv@define@key{class@affiliation}{name*}{\def\class@@affil@alt{#1}}

% 选择 main 或者 alt
\newcommand\class@format@affiliations[1]{%
  \kv@set@family@handler{class@affiliations}{%
    \kvsetkeys{class@affiliation}{##2}%
    \textsuperscript{\csname class@affil@number@##1\endcsname)}%
    (\@nameuse{class@@affil@#1})\par%
  }%
  \begingroup
    \kvsetkeys@expandafter{class@affiliations}{\class@affiliations}%
  \endgroup
}

% 标题页的脚注
\newcommand\class@title@footnote@main{%
  \kv@set@family@handler{class@authors}{%
    \class@@correspondingfalse
    \kvsetkeys{class@author}{##2}%
    \class@@name@main
    \ifclass@@corresponding
      （\textsf{通信作者}）%
    \fi
    ，%
    \class@@biography\space
    \ifx\class@@email\@empty\else
      E-mail: \email{\class@@email}.
    \fi
  }%
  \footnotetext{%
    收稿日期：\class@received@date ；%
    修改日期：\class@revised@date\quad
    \class@grants
    \kvsetkeys@expandafter{class@authors}{\class@authors}
  }%
  \kv@set@family@handler{class@authors}{%
    \kvsetkeys{class@author}{##2}%
    \kv@break
  }%
  \let\class@@phone\@empty
  \kvsetkeys@expandafter{class@authors}{\class@authors}
  \ifx\class@@phone\@empty\else
    \footnotetext{%
      第1作者手机号码：\class@@phone，
      E-mail:
      \ifx\class@@email\@empty\else
        \email{\class@@email}%
      \fi
    }%
  \fi
}


% 章节标题

% 用 \pkg{ctex} 的接口设置全部章节标题格式。

% 一级标题：4 号黑体，段前 8 磅，段后 8 磅。
\ctexset{
  section = {
    format       = \zihao{4},
    nameformat   = \heiti,
    numberformat = \bfseries,
    titleformat  = \heiti,
    % fixskip = true,
    beforeskip   = 8bp,
    afterskip    = 8bp,
    afterindent  = true,
  },
  %
  % 二级标题：5 号黑体，段前 0.25 行，段后 0.25 行。
  subsection = {
    format       = \zihao{5},
    nameformat   = \heiti,
    numberformat = \bfseries,
    titleformat  = \heiti,
    beforeskip   = 2.625bp,
    afterskip    = 2.625bp,
    afterindent  = true,
  },
  %
  % 三级节标题：5 号宋体，段前段后 0 磅。
  subsubsection = {
    format       = \zihao{5},
    beforeskip   = \z@,
    afterskip    = \z@,
    afterindent  = true,
  },
  appendix = {
    name = {\appendixname\space},
  },
}


% URL 的字体设为保持原样。
\urlstyle{same}

% 使用 \pkg{xurl} 宏包的方法，增加 URL 可断行的位置。
\def\UrlBreaks{%
  \do\/%
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l%
     \do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z%
  \do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L%
     \do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z%
  \do0\do1\do2\do3\do4\do5\do6\do7\do8\do9\do=\do/\do.\do:%
  \do\*\do\-\do\~\do\'\do\"\do\-}
\Urlmuskip=0mu plus 0.1mu

\DeclareRobustCommand\doi[1]{%
  \edef\class@@url@tmp{#1}%
  \expandafter\@doi\expandafter{\class@@url@tmp}%
}
\DeclareUrlCommand\@doi{\urlstyle{rm}}
\DeclareRobustCommand\email[1]{%
  \edef\class@@url@tmp{#1}%
  \expandafter\@email\expandafter{\class@@url@tmp}%
}
\DeclareUrlCommand\@email{\urlstyle{rm}}


% \subsection{浮动体}

% \LaTeX{} 对放置浮动体的要求比较强，这里按照 UK TeX FAQ 的建议
% \footnote{\url{https://texfaq.org/FAQ-floats}} 对其适当放宽。
\renewcommand\topfraction{.85}
\renewcommand\bottomfraction{.7}
\renewcommand\textfraction{.15}
\renewcommand\floatpagefraction{.66}
\renewcommand\dbltopfraction{.66}
\renewcommand\dblfloatpagefraction{.66}
\setcounter{topnumber}{9}
\setcounter{bottomnumber}{9}
\setcounter{totalnumber}{20}
\setcounter{dbltopnumber}{9}

% 修改默认的浮动体描述符为 |htb|。
\def\fps@figure{htb}
\def\fps@table{htb}

% 用 \pkg{caption} 宏包设置图、表的格式：

% 图片说明字体为小 5 号。

% 表号、表题置于表的上方，宋体 10.5 磅居中，单倍行距，段前 6 磅，段后 6 磅，
% 表号与表题文字之间空一字，表号、表题加粗。
% 表注左缩进两字，续行悬挂缩进左对齐，两端对齐。
\setlength{\floatsep}{6bp}
\setlength{\textfloatsep}{6bp}
\setlength{\intextsep}{6bp}
\captionsetup{
  justification  = centerlast,
  font           = small,
  labelsep       = quad,
  skip           = 6bp,
  figureposition = bottom,
  tableposition  = top,
}
\captionsetup[table]{
  font = {sf,small},
}


% \subsection{数学符号}

% 根据中文的数学排印习惯进行设置：

% 省略号一律居中，所以 \cs{ldots} 不再居于底部。
\ifclass@language@chinese
  \def\mathellipsis{\cdots}
\fi

% 小于等于号、大于等于号要使用倾斜的字形。
\protected\def\le{\leqslant}
\protected\def\ge{\geqslant}
\AtBeginDocument{%
  \renewcommand\leq{\leqslant}%
  \renewcommand\geq{\geqslant}%
}

% 积分号的上下限默认置于上下两侧。
\removenolimits{%
  \int\iint\iiint\iiiint\oint\oiint\oiiint
  \intclockwise\varointclockwise\ointctrclockwise\sumint
  \intbar\intBar\fint\cirfnint\awint\rppolint
  \scpolint\npolint\pointint\sqint\intlarhk\intx
  \intcap\intcup\upint\lowint
}

% 实部、虚部操作符使用罗马体 $\mathrm{Re}$、$\mathrm{Im}$ 而不是 fraktur 体
% $\Re$、$\Im$。
\AtBeginDocument{%
  \renewcommand\Re{\operatorname{Re}}%
  \renewcommand\Im{\operatorname{Im}}%
}

% 兼容旧的粗体命令：\pkg{bm} 的 \cs{bm} 和 \pkg{amsmath} 的 \cs{boldsymbol}。
\newcommand\bm{\symbf}
\renewcommand\boldsymbol{\symbf}

% 兼容 \pkg{amssymb} 中的命令。
\newcommand\square{\mdlgwhtsquare}

% \subsubsection{数学定理}

\newtheoremstyle{cjc}
  {\z@}{\z@}
  {}{2\ccwd}
  {\bfseries}{.}
  {\ccwd}{}
\theoremstyle{cjc}
% 定义新的定理
\newcommand\class@assertionname{断言}
\newcommand\class@assumptionname{假设}
\newcommand\class@axiomname{公理}
\newcommand\class@corollaryname{推论}
\newcommand\class@definitionname{定义}
\newcommand\class@examplename{例}
\newcommand\class@lemmaname{引理}
\newcommand\class@proofname{证明}
\newcommand\class@propositionname{命题}
\newcommand\class@remarkname{注}
\newcommand\class@theoremname{定理}
\newtheorem{theorem}             {\class@theoremname}
\newtheorem{assertion}  [theorem]{\class@assertionname}
\newtheorem{axiom}      [theorem]{\class@axiomname}
\newtheorem{corollary}  [theorem]{\class@corollaryname}
\newtheorem{lemma}      [theorem]{\class@lemmaname}
\newtheorem{proposition}[theorem]{\class@propositionname}
\newtheorem{assumption}          {\class@assumptionname}
\newtheorem{definition}          {\class@definitionname}
\newtheorem{example}             {\class@examplename}
\newtheorem*{remark}             {\class@remarkname}
% \pkg{amsthm} 单独定义了 proof 环境，这里重新定义以满足格式要求。
% 原本模仿 \pkg{amsthm} 写成 |\item[\hskip\labelsep\hskip2\ccwd #1\hskip\ccwd]|，
% 但是却会多出一些间隙。
\DeclareRobustCommand{\qed}{证毕.}
\renewenvironment{proof}[1][\proofname]{\par
  \textbf{\proofname}.\quad
}{%
  \par\raggedleft\qed\par
}


% \subsection{参考文献}

\newcommand\bibstyle@cjc{\bibpunct{[}{]}{,}{s}{,}{\textsuperscript{,}}}
\citestyle{cjc}

% 参考文献列表格式：宋体 10.5 磅，行距 20 磅，续行缩进两字，左对齐。
\renewcommand\bibsection{%
  \begingroup
    \ctexset{
      section = {
        format = \centering\fontsize{10.5bp}{16bp}\linespread{1}\selectfont,
        beforeskip = 16bp,
        afterskip = 16bp,
      },
    }%
    \section*{\refname}%
  \endgroup
}
\renewcommand\bibfont{\fontsize{7.5bp}{14bp}\linespread{1}\selectfont}
\renewcommand\@biblabel[1]{[#1]\hfill}
\setlength{\bibsep}{\z@}


% 附录

\newenvironment{acknowledgments}{%
  \kaishu\zihao{-5}\noindent
  \textsf{致\quad 谢}\quad
}{}

\g@addto@macro\appendix{%
  \ctexset{
    section = {
      format     = \zihao{5},
      beforeskip = \z@,
      afterskip  = \z@,
    },
  }%
  \zihao{-5}%
}

\newcommand\makebiographies{%
  \kv@set@family@handler{class@authors}{%
    \kvsetkeys{class@author}{##2}%
    \noindent
    \textbf{\class@@name@alt},\space
    \class@@biography@alt\par
  }%
  \begingroup
    \zihao{-5}%
    \par\null\par
    \kvsetkeys@expandafter{class@authors}{\class@authors}
  \endgroup
}

\newenvironment{background}{%
  \zihao{-5}%
  \par\null\par
  \noindent\textbf{Background}\par
}{}


% 其他宏包的设置

% hyperref

\AtEndOfPackageFile*{hyperref}{
  \hypersetup{
    colorlinks         = true,
    bookmarksnumbered  = true,
    bookmarksopen      = true,
    bookmarksopenlevel = 2,
    unicode            = true,
    psdextra           = true,
  }
  \DeclareRobustCommand\@doi[1]{\href{https://doi.org/#1}{\nolinkurl{#1}}}
  \DeclareRobustCommand\@email[1]{\href{mailto:#1}{\nolinkurl{#1}}}
  %
  % 在 PDF 字符串中去掉换行，以减少 \pkg{hyperref} 的警告信息。
  \pdfstringdefDisableCommands{
    \let\\\@empty
    \let\hspace\@gobble
  }
  %
  % \pkg{hyperref} 与 \pkg{unicode-math} 存在一些兼容性问题，见
  % \href{https://github.com/ustctug/ustcthesis/issues/223}{
  %   ustctug/ustcthesis\#223} 和
  % \href{https://github.com/ho-tex/hyperref/pull/90}{ho-tex/hyperref\#90}。
  \@ifpackagelater{hyperref}{2019/04/27}{}{%
    \g@addto@macro\psdmapshortnames{\let\mu\textmugreek}%
  }
  %
  % 设置中文的 \cs{autoref}。
  % \footnote{\url{https://tex.stackexchange.com/a/66150/82731}}
  \ifclass@language@chinese
    \def\equationautorefname~#1\null{公式~(#1)\null}
    \def\footnoteautorefname{脚注}
    \def\itemautorefname~#1\null{第~#1 项\null}
    \def\figureautorefname{图}
    \def\tableautorefname{表}
    \def\appendixautorefname{附录}
    \def\sectionautorefname~#1\null{第~#1 节\null}
    \def\subsectionautorefname~#1\null{第~#1 节\null}
    \def\subsubsectionautorefname~#1\null{第~#1 节\null}
    \def\theoremautorefname{定理}
    \def\HyRef@autopageref#1{\hyperref[{#1}]{第~\pageref*{#1} 页}}
  \fi
}


% siunitx 宏包

\AtEndOfPackageFile*{siunitx}{
  \sisetup{
    group-minimum-digits = 4,
    separate-uncertainty = true,
    inter-unit-product   = \ensuremath{{}\cdot{}},
  }
  \ifclass@language@chinese
    \sisetup{
      list-final-separator = { 和 },
      list-pair-separator  = { 和 },
      range-phrase         = {～},
    }
  \fi
}


% algorithmic 宏包

\AtEndOfPackageFile*{algorithmic}{
  \renewcommand{\algorithmicrequire}{输入：\ignorespaces}
  \renewcommand{\algorithmicensure}{输出：\ignorespaces}
  \renewcommand{\algorithmicend}{\textbf{END}}
  \renewcommand{\algorithmicif}{\textbf{IF}}
  \renewcommand{\algorithmicthen}{\textbf{THEN}}
  \renewcommand{\algorithmicelse}{\textbf{ELSE}}
  \renewcommand{\algorithmicelsif}{\algorithmicelse\ \algorithmicif}
  \renewcommand{\algorithmicendif}{\algorithmicend\ \algorithmicif}
  \renewcommand{\algorithmicfor}{\textbf{FOR}}
  \renewcommand{\algorithmicforall}{\textbf{FOR ALL}}
  \renewcommand{\algorithmicdo}{\textbf{DO}}
  \renewcommand{\algorithmicendfor}{\algorithmicend\ \algorithmicfor}
  \renewcommand{\algorithmicwhile}{\textbf{WHILE}}
  \renewcommand{\algorithmicendwhile}{\algorithmicend\ \algorithmicwhile}
  \renewcommand{\algorithmicloop}{\textbf{LOOP}}
  \renewcommand{\algorithmicendloop}{\algorithmicend\ \algorithmicloop}
  \renewcommand{\algorithmicrepeat}{\textbf{REPEAT}}
  \renewcommand{\algorithmicuntil}{\textbf{UNTIL}}
  \renewcommand{\algorithmicprint}{\textbf{PRINT}}
  \renewcommand{\algorithmicreturn}{\textbf{RETURN}}
  \renewcommand{\algorithmictrue}{\textbf{TRUE}}
  \renewcommand{\algorithmicfalse}{\textbf{FALSE}}
}

% \PassOptionsToPackage{plaintop}{algorithm}
\AtEndOfPackageFile*{algorithm}{
  \def\@fs@cfont{\sffamily}
  \renewcommand\floatc@ruled[2]{{\@fs@cfont #1}\quad#2\par}
  \restylefloat{algorithm}
  \floatname{algorithm}{算法}
  \newfloat{procedure}{htb}{loa}{}
  \floatname{procedure}{过程}
}
