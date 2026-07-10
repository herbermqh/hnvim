local ls = require('luasnip')
local parse_snippet = ls.parser.parse_snippet
local utils = require('arttexsnippets.util.utils')
local is_math = utils.with_opts(utils.is_math, true)
local not_math = utils.with_opts(utils.not_math, true)
local line_begin = require('luasnip.extras.conditions.expand').line_begin
local pipe = utils.pipe
local function env(name)
  return function()
    return utils.env(name)
  end
end
local function not_preceded_by(pattern)
  return function(line_to_cursor, matched_trigger)
    local before_match = line_to_cursor:sub(1, -(#matched_trigger + 1))
    return not before_match:find(pattern)
  end
end
local function word_boundary(line_to_cursor, matched_trigger)
  local before_match = line_to_cursor:sub(1, -(#matched_trigger + 1))
  if before_match == '' then return true end
  local last_char = before_match:sub(-1)
  return last_char:match('[%w_]') == nil
end
local M = {}
M.retrieve = function()
  local autosnippets = {}
  local normalsnippets = {}
  table.insert(normalsnippets,   parse_snippet({trig = [=[documentclass]=], name = [=[documentclass]=], priority = -50, wordTrig = false, condition = line_begin}, [=[\documentclass${1:options}{${2:package}}
$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[usepackage]=], name = [=[usepackage]=], priority = -50, wordTrig = false, condition = line_begin}, [=[\usepackage${1:options}{${2:package}}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[doc]=], name = [=[document]=], priority = 500, wordTrig = false}, [=[\begin{document}
${0}
\end{document}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[beg]=], name = [=[begin{} / end{}]=], priority = 500, trigEngine = "ecma", wordTrig = false, condition = not_preceded_by('\\$')}, [=[\begin{$1}
  $0
\end{$1}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[be(gin)?( (\S+))?]=], name = [=[begin{} / end{}]=], priority = 500, trigEngine = "ecma", wordTrig = false}, [=[\begin{${1:}}
	${2:${TM_SELECTED_TEXT}}
\end{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=["\"([a-zA-Z0-9\_\´\sáíóéúÁÉÍÓÚñ,.;:\-]+)\b\"\s"]=], name = [=[smart quotes]=], priority = 500, trigEngine = "ecma", wordTrig = false}, [=[\`\`''$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[text]=], name = [=[text]=], priority = 500, wordTrig = false, condition = is_math}, [=[\\text{${1:${VISUAL:text}}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[textit]=], name = [=[italic text]=], priority = 500, wordTrig = false}, [=[\\textit{${1:${VISUAL:text}}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[textbf]=], name = [=[bold face text]=], priority = 500, wordTrig = false}, [=[\\textbf{${1:${VISUAL:text}}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[underline]=], name = [=[underline text]=], priority = 500, wordTrig = false}, [=[\\underline{${1:${VISUAL:text}}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[overline]=], name = [=[overline text]=], priority = 500, wordTrig = false}, [=[\\overline{${1:${VISUAL:text}}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[center]=], name = [=[center]=], priority = 500, trigEngine = "ecma", wordTrig = false, condition = not_preceded_by('{$')}, [=[\begin{center}
  $0
\end{center}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[mul2]=], name = [=[two-column environment with multicol]=], priority = 100, wordTrig = false}, [=[\begin{multicols}{2}
	${0}
\end{multicols}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[amul2]=], name = [=[two-column environment with multicol]=], priority = 200, wordTrig = false}, [=[\begin{artmulticols}{2}
	${0}
\end{artmulticols}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[mul3]=], name = [=[En tres columna]=], priority = 200, wordTrig = false}, [=[\begin{multicols}{3}
	${0}
\end{multicols}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[asy]=], name = [=[Entorno asymptote]=], priority = 200, trigEngine = "ecma", wordTrig = false, condition = not_preceded_by('{$')}, [=[\begin{asy}
  $0
\end{asy}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[minipage]=], name = [=[Minipage]=], priority = 200, wordTrig = false}, [=[\begin{minipage}[$1]{$2}
  $0
\end{minipage}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[parboxImage]=], name = [=[Parbox image]=], priority = 200, wordTrig = false}, [=[	\parbox{\widthparbox}{\pgfimage[width=\widthparbox]{\rootimage/${0}}}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[parboxText]=], name = [=[Parbox text]=], priority = 200, wordTrig = false}, [=[\parbox{\widthparbox}{
  ${0}
}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[casy]=], name = [=[codetex]=], priority = 200, wordTrig = false}, [=[\begin{codeasy}{lefthand ratio=0.6}
  $0
\end{codeasy}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ct]=], name = [=[codetex]=], priority = 200, wordTrig = false}, [=[\begin{codetex}{lefthand ratio=0.6}
  $0
\end{codetex}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[pt]=], name = [=[plaintex]=], priority = 200, wordTrig = false}, [=[\begin{plaintex}
  $0
\end{plaintex}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ctl]=], name = [=[codetex]=], priority = 200, wordTrig = false}, [=[\begin{codetexlong}
  $0
\end{codetexlong}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ctc]=], name = [=[codetexcomment]=], priority = 10000, wordTrig = false}, [=[\begin{codetexcomment}{lefthand ratio=0.6}
  $0
\end{codetexcomment}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ctcl]=], name = [=[codetexcommentlong]=], priority = 10000, wordTrig = false}, [=[\begin{codetexcommentlong}
  $0
\end{codetexcommentlong}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[cxtcl]=], name = [=[codexetexcommentlong]=], priority = 10000, wordTrig = false}, [=[\begin{codexetexcommentlong}
  $0
\end{codexetexcommentlong}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[nt]=], name = [=[Note]=], priority = 200, wordTrig = false}, [=[\\note{$0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[lnt]=], name = [=[long note]=], priority = 400, wordTrig = false}, [=[\begin{longnote}
  $0
\end{longnote}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[nts]=], name = [=[Note]=], priority = 400, wordTrig = false}, [=[\\note*{$0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[enum]=], name = [=[Enumerate]=], priority = 400, wordTrig = false}, [=[\begin{enumerate}
  \item $0
\end{enumerate}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[enuma]=], name = [=[Enumerate]=], priority = 400, wordTrig = false}, [=[\begin{enumerate}[a)]
  \item $0
\end{enumerate}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[enumi]=], name = [=[Enumerate]=], priority = 400, wordTrig = false}, [=[\begin{enumerate}[i)]
  \item $0
\end{enumerate}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[enumd]=], name = [=[Enumerate]=], priority = 400, wordTrig = false}, [=[\begin{enumdesc}[$1]
  \item $0
\end{enumdesc}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[premise]=], name = [=[Enumerate]=], priority = 400, wordTrig = false}, [=[\begin{premises}
  \item $0
\end{premises}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[axiom]=], name = [=[Enumerate]=], priority = 400, wordTrig = false}, [=[\begin{axioms}[$1]
  \item $0
\end{axioms}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[props]=], name = [=[Enumerate]=], priority = 400, wordTrig = false}, [=[\begin{props}
  \item $0
\end{props}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[item]=], name = [=[Itemize]=], priority = 400, wordTrig = false}, [=[\begin{itemize}
  \item $0
\end{itemize}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = 400, trigEngine = "ecma", wordTrig = false, condition = env('enumerate')}, [=[\item $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = 400, trigEngine = "ecma", wordTrig = false, condition = env('questions')}, [=[\item $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = 400, trigEngine = "ecma", wordTrig = false, condition = env('itemize')}, [=[\item $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = 400, trigEngine = "ecma", wordTrig = false, condition = env('listproposition')}, [=[\item $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = 400, trigEngine = "ecma", wordTrig = false, condition = env('listpremise')}, [=[\item $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = 400, trigEngine = "ecma", wordTrig = false, condition = env('listaxiom')}, [=[\item $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = 400, trigEngine = "ecma", wordTrig = false, condition = env('description')}, [=[\item[$1] $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\s\sit]=], name = [=[item]=], priority = -100, trigEngine = "ecma", wordTrig = false, condition = env('desc')}, [=[\item[$1] $0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[desc]=], name = [=[Description]=], priority = -100, wordTrig = false}, [=[\begin{description}
  \item[$1] $0
\end{description}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ldes]=], name = [=[List description]=], priority = 500, wordTrig = false}, [=[\begin{desc}
  \item[$1] $0
\end{desc}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ldenum]=], name = [=[Lista con nombre]=], priority = 500, wordTrig = false}, [=[\begin{listdescriptionenum}
  \item ${0}
\end{listdescriptionenum}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[qt]=], name = [=[Preguntas]=], priority = 500, wordTrig = false}, [=[\begin{questions}
  \item ${0}
\end{questions}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[maketitle]=], name = [=[maketitle]=], priority = 500, wordTrig = false}, [=[\maketitle]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[exerl]=], name = [=[Ecuacion]=], priority = 500, trigEngine = "ecma", wordTrig = false}, [=[\exerciselevel{$0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[exersec]=], name = [=[Ecuacion]=], priority = 500, trigEngine = "ecma", wordTrig = false}, [=[\sectionexercise{$0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[exersubsec]=], name = [=[Ecuacion]=], priority = 500, trigEngine = "ecma", wordTrig = false}, [=[\subsectionexercise{$0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[et]=], name = [=[Ecuacion]=], priority = 500, trigEngine = "ecma", wordTrig = false}, [=[\ltag{\marrow{${1:a}}}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[chapter]=], name = [=[chapter]=], priority = 500, wordTrig = false}, [=[\chapter{$0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[SSE]=], name = [=[section]=], priority = 500, wordTrig = false}, [=[\section{$0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[SSS]=], name = [=[subsection]=], priority = 500, wordTrig = false}, [=[\subsection{$0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[SS2]=], name = [=[subsubsection]=], priority = 500, wordTrig = false}, [=[\subsubsection{$0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[SF]=], name = [=[subfragment]=], priority = 500, wordTrig = false}, [=[\subfragment{$0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[figref]=], name = [=[reference to a figure]=], priority = 500, wordTrig = false}, [=[\\ref{fig:${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tabref]=], name = [=[reference to a table]=], priority = 500, wordTrig = false}, [=[\\ref{tab:${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[listingref]=], name = [=[reference to a listing]=], priority = 500, wordTrig = false}, [=[${1:Listing}~\\ref{${2:list}}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[sectionref]=], name = [=[reference to a section]=], priority = 500, wordTrig = false}, [=[\\ref{sec:${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[pageref]=], name = [=[reference to a page]=], priority = 500, wordTrig = false}, [=[\\pageref{${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[index]=], name = [=[index]=], priority = 500, wordTrig = false}, [=[\\index{${1:index}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[citen]=], name = [=[\citen]=], priority = 500, wordTrig = false}, [=[\\citen{${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[citep]=], name = [=[\citep]=], priority = 500, wordTrig = false}, [=[\\citep{${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[citet]=], name = [=[\citet]=], priority = 500, wordTrig = false}, [=[\\citet{${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[cite]=], name = [=[\cite[]{}]=], priority = 500, wordTrig = false}, [=[\\cite[${1}]{${2}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[citea]=], name = [=[\citeauthor]=], priority = 500, wordTrig = false}, [=[\\citeauthor{${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[citey]=], name = [=[\citeyear]=], priority = 500, wordTrig = false}, [=[\\citeyear{${1}} ${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[footcite]=], name = [=[\footcite[]{}]=], priority = 500, wordTrig = false}, [=[\\footcite[${1}]{${2}}${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[def]=], name = [=[Definición]=], priority = 500, wordTrig = false}, [=[\begin{definition}[$1]
	$0
\end{definition}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[prop]=], name = [=[Proposición]=], priority = 500, wordTrig = false}, [=[\begin{proposition}[$1]
  $0
\end{proposition}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[cor]=], name = [=[Corolario]=], priority = 500, wordTrig = false}, [=[\begin{corollary}[$1]
  $0
\end{corollary}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[dem]=], name = [=[Demostracion]=], priority = 500, wordTrig = false}, [=[\begin{demostration}
	$0
\end{demostration}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[teo]=], name = [=[Teorema]=], priority = 500, wordTrig = false}, [=[\begin{theorem}
	${0}
\end{theorem}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[exa]=], name = [=[Ejemplo en una sola columna]=], priority = 500, wordTrig = false}, [=[\begin{example}
  $0
\end{example}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[exas]=], name = [=[Ejemplo en una sola columna]=], priority = 500, wordTrig = false}, [=[\begin{examples}
  $0
\end{examples}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[exes]=], name = [=[Ejemplo en una sola columna]=], priority = 500, wordTrig = false}, [=[\begin{exercises}
  $0
\end{exercises}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ell]=], name = [=[Ejemplo ilustrativo]=], priority = 500, wordTrig = false}, [=[\begin{exampleillustrative}
  $0
\end{exampleillustrative}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[pr]=], name = [=[Def problema]=], priority = 500, wordTrig = false}, [=[\newproblem{$1}{%
  $0
}{%

}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[mb]=], name = [=[mbox]=], priority = 500, wordTrig = false, condition = is_math}, [=[\mbox{${1}} ${0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\sec]=], name = [=[Ecuacion]=], priority = 500, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\tag{$1} $0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[lta]=], name = [=[Ecuacion]=], priority = 500, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\ltag{\aarrow{$1}}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ltm]=], name = [=[Ecuacion]=], priority = 500, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\ltag{\marrow{${1:a}}}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[__]=], name = [=[subscript]=], priority = 500, wordTrig = false, condition = is_math}, [=[_{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[xnn]=], name = [=[xn]=], priority = 500, wordTrig = false, condition = is_math}, [=[x_{n}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[ynn]=], name = [=[yn]=], priority = 500, wordTrig = false, condition = is_math}, [=[y_{n}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[xii]=], name = [=[xi]=], priority = 500, wordTrig = false, condition = is_math}, [=[x_{i}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[yii]=], name = [=[yi]=], priority = 500, wordTrig = false, condition = is_math}, [=[y_{i}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[xjj]=], name = [=[xj]=], priority = 500, wordTrig = false, condition = is_math}, [=[x_{j}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[yjj]=], name = [=[yj]=], priority = 500, wordTrig = false, condition = is_math}, [=[y_{j}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[xp1]=], name = [=[x]=], priority = 500, wordTrig = false, condition = is_math}, [=[x_{n+1}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[xmm]=], name = [=[x]=], priority = 500, wordTrig = false, condition = is_math}, [=[x_{m}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[stt]=], name = [=[text subscript]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('i$')})}, [=[_{\text{$1}}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[^^]=], name = [=[Description]=], priority = 100, wordTrig = false, condition = is_math}, [=[^{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[dm]=], name = [=[Math]=], priority = 100, wordTrig = true}, [=[\[${1:${TM_SELECTED_TEXT}}\]$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[//]=], name = [=[Fraction]=], priority = 100, wordTrig = false, condition = is_math}, [=[\\frac{$1}{$2}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`2]=], name = [=[\sqrt{}]=], priority = 100, wordTrig = false, condition = is_math}, [=[\sqrt{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[dint]=], name = [=[integral]=], priority = 300, wordTrig = true, condition = is_math}, [=[\int_{${1:-\infty}}^{${2:\infty}} ${3:${TM_SELECTED_TEXT}} $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[sum]=], name = [=[sum]=], priority = 300, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('\\$'), word_boundary})}, [=[\sum\limits_{${1:i}=${2:1}}^{${3:n}}${0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[prod]=], name = [=[product]=], priority = 300, wordTrig = false, condition = is_math}, [=[\prod\limits_{${1:i}=${2:1}}^{${3:n}}${0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[lim]=], name = [=[limit]=], priority = 300, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('\\$')})}, [=[\lim\limits_{${1:x}\to ${2:0}}${0}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[·]=], name = [=[cdot]=], priority = 100, wordTrig = false, condition = is_math}, [=[\cdot$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[...]=], name = [=[ldots]=], priority = 100, wordTrig = false, condition = is_math}, [=[\ldots$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[v...]=], name = [=[ldots]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\vdots$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[d...]=], name = [=[ldots]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\ddots$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[c...]=], name = [=[cdot]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\cdots$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(\)\))]=], name = [=[left( right)]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('t$')})}, [=[\left($1\right)$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(\|\|)]=], name = [=[left| right|]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('t$')})}, [=[\left|$1\right|$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(\}\})]=], name = [=[left\{ right\}]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('t$')})}, [=[\left\\{$1\right\\}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(\]\])]=], name = [=[left[ right]]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('t$')})}, [=[\left[$1\right]$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(n\|)]=], name = [=[norm]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('t$')})}, [=[\left\|$1\right\|$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(\.\|)]=], name = [=[left. right|]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('t$')})}, [=[\left. $1\right|$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[ceil]=], name = [=[ceil]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\left\lceil $1 \right\rceil $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[floor]=], name = [=[floor]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\left\lfloor $1 \right\rfloor $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[conj]=], name = [=[conjugate]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\overline{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[bar]=], name = [=[overline]=], priority = 10, wordTrig = false, condition = is_math}, [=[\overline{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[latex]=], name = [=[overline]=], priority = 10, trigEngine = "ecma", wordTrig = false}, [=[\LaTeX]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[¯(\w|\d+)]=], name = [=[overline]=], priority = 10, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\overline{}$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(\w+)¯]=], name = [=[overline]=], priority = 10, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('[\\n%w]$')})}, [=[\overline{}$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`^]=], name = [=[hat]=], priority = 10, wordTrig = false, condition = is_math}, [=[\hat{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[\su(\w+)\b\s]=], name = [=[Vector postfix]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\hat{}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[→([a-zA-Z0])]=], name = [=[Vector postfix]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('→$')})}, [=[\vv{}$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[([a-zA-Z]+)→]=], name = [=[Vector postfix]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('[\\n%w%d]$')})}, [=[\vv{}$1]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[→→([\\a-zA-Z]+)]=], name = [=[Vector postfix]=], priority = 500, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\vv{}$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[tt]=], name = [=[text]=], priority = -50, wordTrig = false, condition = is_math}, [=[\text{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(tbf)]=], name = [=[functions math]=], priority = -50, trigEngine = "ecma", wordTrig = false, condition = pipe({not_preceded_by('tex$'), word_boundary})}, [=[\bfseries]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[` ]=], name = [=[space in math mode]=], priority = -50, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\;]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[equation]=], name = [=[equation]=], priority = -50, wordTrig = false}, [=[\begin{equation}
  $0
\end{equation}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[matrix]=], name = [=[matrix environment]=], priority = -50, wordTrig = false}, [=[\begin{${1:p/b/v/V/B/small}matrix}
  $0
\end{$1matrix}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[pmat]=], name = [=[pmat]=], priority = -50, wordTrig = false}, [=[\begin{pmatrix}
  $1
\end{pmatrix} $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[bmat]=], name = [=[bmat]=], priority = -50, wordTrig = false}, [=[\begin{bmatrix}
  $1
\end{bmatrix} $0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ali]=], name = [=[Align]=], priority = -50, wordTrig = false}, [=[\begin{align*}
  ${1:${TM_SELECTED_TEXT}}
\end{align*}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[cjt]=], name = [=[Conjunto de ecuaciones]=], priority = -50, wordTrig = false, condition = is_math}, [=[\left[
\begin{aligned}
  ${0}
\end{aligned}
\right.]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[stm]=], name = [=[Sistema de ecuaciones]=], priority = 100, wordTrig = false, condition = is_math}, [=[\begin{systemeq}
  ${0}
\end{systemeq}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[form]=], name = [=[Fórmula]=], priority = 100, wordTrig = false}, [=[\begin{formula}
  $0
\end{formula}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ans]=], name = [=[Respuesta]=], priority = 100, wordTrig = false}, [=[\begin{answer}
  ${0}
\end{answer}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ansl]=], name = [=[Respuesta]=], priority = 100, wordTrig = false}, [=[\answerinline{${0}}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tabox]=], name = [=[Tabla en caja]=], priority = 100, wordTrig = false}, [=[\begin{empheq}[box=\tabox{${1:título}}]{align*}
  ${0}
\end{empheq}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`']=], name = [=[prima]=], priority = 100, wordTrig = false, condition = is_math}, [=[\prime$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`a]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\alpha$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[à]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\alpha$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`b]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\beta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`c]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\chi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`d]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\delta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`e]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\varepsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[è]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\varepsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`f]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\phi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`g]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\gamma$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`h]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\eta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`i]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\iota$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`k]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\kappa$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`l]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\lambda$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`m]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\mu$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`n]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\nu$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`p]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\pi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`q]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\theta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`r]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\rho$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`s]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\sigma$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`t]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\tau$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`u]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\upsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[ù]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\upsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`v]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\varsigma$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`w]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\omega$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`x]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\xi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`y]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\psi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`z]=], name = [=[letra griega minuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\zeta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`A]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Alpha$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[À]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Alpha$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`B]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Beta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`C]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Chi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`D]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Delta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`E]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Varepsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[È]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Varepsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`F]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Varphi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`G]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Gamma$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`H]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Eta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`I]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Iota$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[Ì]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Iota$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`K]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Kappa$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`L]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Lambda$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`M]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Mu$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`N]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Nu$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`O]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Omicron$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`P]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Pi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`Q]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Theta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`R]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Rho$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`S]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Sigma$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`T]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Tau$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`U]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Upsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[Ù]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Upsilon$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`V]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Varsigma$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`W]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Omega$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`X]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Xi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`Y]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Psi$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`Z]=], name = [=[letra griega mayuscula]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Zeta$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[+-]=], name = [=[pm]=], priority = 100, wordTrig = false, condition = is_math}, [=[\pm $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[+-]=], name = [=[mp]=], priority = 100, wordTrig = false, condition = is_math}, [=[\pm $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[xx]=], name = [=[cross]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\times$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`o]=], name = [=[circ]=], priority = 1000, wordTrig = false, condition = is_math}, [=[\circ$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[II]=], name = [=[cap]=], priority = -10, wordTrig = false, condition = is_math}, [=[\cap$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[bII]=], name = [=[cap]=], priority = 100, wordTrig = false, condition = is_math}, [=[\bigcap$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[UU]=], name = [=[cup]=], priority = -10, wordTrig = false, condition = is_math}, [=[\cup$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[bUU]=], name = [=[cup]=], priority = 100, wordTrig = false, condition = is_math}, [=[\bigcup$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[oo]=], name = [=[or]=], priority = 100, wordTrig = false, condition = is_math}, [=[\lor $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[yy]=], name = [=[or]=], priority = 100, wordTrig = false, condition = is_math}, [=[\wedge $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[O+]=], name = [=[oplus]=], priority = 100, wordTrig = false, condition = is_math}, [=[\oplus $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[O-]=], name = [=[ominus]=], priority = 100, wordTrig = false, condition = is_math}, [=[\ominus $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[Ox]=], name = [=[otimes]=], priority = 100, wordTrig = false, condition = is_math}, [=[\otimes $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[CC]=], name = [=[subset]=], priority = 100, wordTrig = false, condition = is_math}, [=[\subset $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[==]=], name = [=[equals]=], priority = 100, wordTrig = false, condition = is_math}, [=[&= $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[mcal]=], name = [=[mathcal]=], priority = 100, wordTrig = false, condition = is_math}, [=[\mathcal{$1}$0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[<->]=], name = [=[leftrightarrow]=], priority = 200, wordTrig = false, condition = is_math}, [=[\leftrightarrow $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[>>]=], name = [=[letra griega minuscula]=], priority = 200, wordTrig = false, condition = is_math}, [=[\to$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[!>]=], name = [=[mapsto]=], priority = 200, wordTrig = false, condition = is_math}, [=[\mapsto $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[~|nn]=], name = [=[~]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\sim $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[=>|ee]=], name = [=[implies]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\Rightarrow $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[=<]=], name = [=[implied by]=], priority = 100, wordTrig = false, condition = is_math}, [=[\Leftarrow $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[<=>|sss]=], name = [=[leftrightarrow]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\Leftrightarrow $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[€]=], name = [=[leftrightarrow]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\in$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(leq|geq|parallel|equiv|approx|cong|propto|perp)]=], name = [=[symb relations math]=], priority = -1000, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('[\\n%w]$'), word_boundary})}, [=[\\$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(nleq|ngeq|nin|nequiv|nparllel|napprox|ncong|npropto|nperp)]=], name = [=[negation sym relations]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('\\$'), word_boundary})}, [=[\\not\\$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[nCC]=], name = [=[subset]=], priority = 200, wordTrig = false, condition = is_math}, [=[\not\subset $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[n=]=], name = [=[not equal]=], priority = 200, wordTrig = false, condition = is_math}, [=[\neq $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[ell]=], name = [=[l]=], priority = 200, wordTrig = false, condition = is_math}, [=[\ell$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`6]=], name = [=[partial]=], priority = 200, wordTrig = false, condition = is_math}, [=[\partial$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[`8]=], name = [=[\infty]=], priority = 200, wordTrig = false, condition = is_math}, [=[\infty$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[ø]=], name = [=[emptyset]=], priority = 200, wordTrig = false, condition = is_math}, [=[\emptyset $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[nab]=], name = [=[nabla]=], priority = 200, wordTrig = false, condition = is_math}, [=[\nabla $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[EE]=], name = [=[exists]=], priority = 200, wordTrig = false, condition = is_math}, [=[\exists $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[nEE]=], name = [=[not exists]=], priority = 200, wordTrig = false, condition = is_math}, [=[\not\exists $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[AA]=], name = [=[forall]=], priority = 200, wordTrig = false, condition = is_math}, [=[\forall $0]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(f|x|y|z)([a-z]+)]=], name = [=[function]=], priority = 200, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('\\$'), word_boundary})}, [=[()$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(v)(f|x|y|z|r|v|a|b|c)([a-z]+)]=], name = [=[vector function]=], priority = 500, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('\\$'), word_boundary})}, [=[\vv{}()$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(sin|cos|tan|sec|csc|cot|ln|log|adj)]=], name = [=[functions math]=], priority = 200, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('[\\a]$'), word_boundary})}, [=[\\$1]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[(asin|acos|atan|asec|acss|acot)]=], name = [=[function trig inverse]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('\\$'), word_boundary})}, [=[\\\left($1\right)$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[(\d+)E([\+\-]?\d+)]=], name = [=[notación científica]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\times10^{}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[\|(R|Q|Z|I|N)]=], name = [=[mathbb R Q Z I]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[\\mathbb{}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[uu]=], name = [=[Unidades]=], priority = 100, wordTrig = false, condition = is_math}, [=[\unit{$1}${0}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[newcommand]=], name = [=[newcommand]=], priority = 100, wordTrig = false}, [=[\newcommand${1:options}{\\${2:name}}{${3:definition}}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[gentbl(\d+)x(\d+)]=], name = [=[Generate table of *width* by *height*]=], priority = 100, trigEngine = "ecma", wordTrig = false}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tr(\d+)]=], name = [=[Add table row of dimension ...]=], priority = 100, trigEngine = "ecma", wordTrig = false}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[table]=], name = [=[Table environment]=], priority = 100, wordTrig = false}, [=[\begin{table}[${1:htpb}]
  $0
  \caption{$2}
  \label{tab:${3:label}}
\end{table}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tabular]=], name = [=[Tabular environment]=], priority = 100, wordTrig = false}, [=[\begin{tabular}{${1:c}}
	${0}
\end{tabular}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[fig]=], name = [=[figure environment]=], priority = 100, wordTrig = false}, [=[\begin{figure}[${1:htpb}]
	$0
	\caption{$2}
	\label{fig:${3:label}}
\end{figure}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[mfig]=], name = [=[figure environment]=], priority = 10000, wordTrig = false}, [=[\begin{marginfigure}%
	$0
	\caption{$1}
	\label{fig:${3:label}}
\end{marginfigure}%]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tikzm]=], name = [=[Figura tikz en el margen]=], priority = 10000, wordTrig = false}, [=[\begin{scaletikzpicturetowidth}{\marginparwidth}
  \begin{tikzpicture}[scale=\tikzscale]
    $1
  \end{tikzpicture}
\end{scaletikzpicturetowidth}
$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[gIn]=], name = [=[Gráfica inecuaciones]=], priority = 10000, wordTrig = false}, [=[\begin{center}
	\begin{scaletikzpicturetowidth}{7cm}
		\begin{tikzpicture}[scale=\\tikzscale]
			\def\numerosCriticos{${0:puntos critico}}
			\def\simbolo{/} %punto critico/simbolo
			\def\cerradoAbierto{/} %punto critico/cerrado o abierto
			\def\inicial{-} %+ o -
			\def\final{+} %+ o -
			\graficaIntervalos
			\scoped[on background layer]{
				\draw[latex-latex, \lineaColor, line width=\lineaGrosor]
				(\inicialX,\yy) -| (,\yy) -- (\finalX,\yy);
			}
		\end{tikzpicture}
	\end{scaletikzpicturetowidth}
\end{center}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[figasy]=], name = [=[Figura asymptote]=], priority = 10000, wordTrig = false}, [=[\begin{figure}[H]
  \centering
  \begin{asy}
    $0
  \end{asy}
  \caption{}
\end{figure}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[grpb]=], name = [=[Gráfica en body]=], priority = 10000, wordTrig = false}, [=[\begin{graphbody}{$1}
  $0
\end{graphbody}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[grpm]=], name = [=[Gráfica en body]=], priority = 10000, wordTrig = false}, [=[\begin{graphmargin}{$1}
  $0
\end{graphmargin}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[grpfw]=], name = [=[Gráfica en body]=], priority = 10000, wordTrig = false}, [=[\begin{graphfullwidth}{$1}
  $0
\end{graphfullwidth}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[subgrp]=], name = [=[Subgráfica]=], priority = 10000, wordTrig = false}, [=[\subgraph{%
  $0
}{$1}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[grpms]=], name = [=[N images en el margen]=], priority = 10000, wordTrig = false}, [=[\begin{graphmargin}{$1}
  \subgraph{%
    $0
  }{$1$2}
  \subgraph{%

  }{$1$3}
\end{graphmargin}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[img]=], name = [=[Imagen sin referencia]=], priority = 10000, wordTrig = false}, [=[\image{$1}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[mtab]=], name = [=[figure environment]=], priority = 10000, wordTrig = false}, [=[\begin{margintable}
	$0
	\caption{$1}
	\label{tab:${3:label}}
\end{margintable}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[plot]=], name = [=[Plot]=], priority = 10000, wordTrig = true}, [=[\begin{figure}[$1]
	\centering
	\begin{tikzpicture}
		\begin{axis}[
			xmin= ${2:-10}, xmax= ${3:10},
			ymin= ${4:-10}, ymax = ${5:10},
			axis lines = middle,
		]
			\addplot[domain=$2:$3, samples=${6:100}]{$7};
		\end{axis}
	\end{tikzpicture}
	\caption{$8}
	\label{${9:$8}}
\end{figure}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[nn]=], name = [=[Tikz node]=], priority = 10000, wordTrig = true}, [=[\node[$5] (${1/[^0-9a-zA-Z]//g}${2}) ${3:at (${4:0,0}) }{$${1}$};
$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tikz]=], name = [=[Entorno tikz]=], priority = 10000, wordTrig = false}, [=[\begin{center}
	\begin{tikzpicture}
		${0}
	\end{tikzpicture}
\end{center}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[mint(ed)?( (\S+))?]=], name = [=[Minted code typeset]=], priority = 10000, trigEngine = "ecma", wordTrig = false}, [=[\begin{minted}{${1}}$0
\end{minted}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[psc]=], name = [=[pseudocode]=], priority = 10000, trigEngine = "ecma", wordTrig = false}, [=[\begin{pseudocode}
  $0
\end{pseudocode}]=]))
  table.insert(autosnippets,   parse_snippet({trig = [=[cin]=], name = [=[mintinline]=], priority = 10000, wordTrig = false}, [=[\mintinline{$1}{$2}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[\\mintinline{tex}{}([#a-zA-Z0-9\@\\\;\*{}\-<>\s\=\/\.\,]+)]=], name = [=[mintinline]=], priority = 10000, trigEngine = "ecma", wordTrig = false}, [=[\mintinline{tex}{}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tc]=], name = [=[texcode]=], priority = -10000, wordTrig = false}, [=[\begin{texcode}
  $0
\end{texcode}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[tic]=], name = [=[texinlinecode]=], priority = -10000, wordTrig = false}, [=[\mintinline{tex}{$1}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[sympy]=], name = [=[sympyblock ]=], priority = -10000, wordTrig = true}, [=[sympy $1 sympy$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[sympy(.*)sympy]=], name = [=[sympy]=], priority = 10000, trigEngine = "ecma", wordTrig = false, condition = word_boundary}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[math]=], name = [=[mathematicablock]=], priority = 1000, wordTrig = true}, [=[math $1 math$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[math(.*)math]=], name = [=[math]=], priority = 10000, trigEngine = "ecma", wordTrig = false, condition = word_boundary}, [=[]=]))
  return { autosnippets = autosnippets, normalsnippets = normalsnippets }
end
return M