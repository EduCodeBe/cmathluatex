--[[ Cmath pour LuaTeX, version 2014.06.04
Christophe Devalland (christophe.devalland@ac-rouen.fr)
http://cdeval.free.fr
Ce programme est libre, vous pouvez le redistribuer et/ou le modifier selon les termes de la Licence Publique Générale GNU telle que publié par la Free Software Foundation ; soit la version 2 de cette licence, soit toute autre version ultérieure.
Ce programme est distribué dans l'espoir qu'il sera utile, mais SANS AUCUNE GARANTIE, ni explicite ni implicite, y compris les garanties de commercialisation ou d'adaptation dans un but spécifique. Prenez connaissance de la Licence Publique Générale GNU pour plus de détails.
--]]

local lpeg = require "lpeg"
-- local table = require "table"
local write = io.write
match = lpeg.match
local C, P, R, S, V = lpeg.C, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local Carg, Cc, Cp, Ct, Cs, Cg, Cf = lpeg.Carg, lpeg.Cc, lpeg.Cp, lpeg.Ct, lpeg.Cs, lpeg.Cg, lpeg.Cf

-- Syntaxe Cmath
local Espace = S(" \n\t")^0
local Guillemet=P('"')
local Guillemet=P('"')
local SepListe=C(S(',;'))
local Operateur=C(	P('<=>')+P('<=')+P('>=')+P('<>')+P('->')+S('=><')
		+	P(':en')+P('≈')
		+	P(':as')+P('⟼')
		+	P(':ap')+P('∈')
		+	P('...')
		+	P('|')
		+	P('⟶')
		+	P(':un')+P('∪')
		+	P(':it')+P('∩')
		+	P(':ro')+P('∘')
		+	P(':eq')+P('~')
		+	P(':co')+P('≡')
		+	P(':pp')+P('∨')
		+	P(':pg')+P('∧')
		+	P(':ve')+P('∧')
		+	P(':pe')+P('⊥')
		+	P(':sd')+P('⊕')
		+	P(':np')+P('∉')
		+	P(':im')+P('⇒')
		+	P(':ev')+P('⟺')
		+	P(':rc')+P('⇐')
		+	P(':ic')+P('⊂')
		+	P(':ni')+P('⊄')
		+	P('⩽')+P('⩾')
		+	P('≠ ')
		) * Espace
				
local TSubstOperateurLaTeX = {	['<=>']='\\Leftrightarrow ', 
		['<=']='\\leqslant ',['⩽']='\\leqslant ',
		['>=']='\\geqslant ',['⩾']='\\geqslant ',
		['<>']='\\\neq ', ['≠']='\\neq ',
		['<']=' < ',
		['>']=' > ',
		['=']=' = ',
		[':en']='\\approx ', ['≈']='\\approx ',
		[':ap']='\\in ', ['∈']='\\in ',
		[':as']='\\longmapsto ', ['⟼']='\\longmapsto ',
		['->']='\\to ',	['⟶']='\\to ',
		['...']='\\dots ',
		['|']='|',
		[':un']='\\cup ', ['∪']='\\cup ',
		[':it']='\\cap ', ['∩']='\\cap ',
		[':ro']='\\circ ', ['∘']='\\circ ',
		[':eq']='\\sim ', ['~']='\\sim ',
		[':co']='\\equiv ', ['≡']='\\equiv ',
		[':pp']='\\vee ', ['∨']='\\vee ',
		[':pg']='\\wedge ', ['∧']='\\wedge ', [':ve']='\\wedge ',
		[':pe']='\\perp ', ['⊥']='\\perp ',
		[':sd']='\\oplus ', ['⊕']='\\oplus ',
		[':np']='\\notin ', ['∉']='\\notin ',
		[':im']='\\Rightarrow ',	['⇒']='\\Rightarrow ',
		[':ev']='\\Leftrightarrow ',	['⟺']='\\Leftrightarrow ',
		[':rc']='\\Leftarrow ', ['⇐']='\\Leftarrow ',
		[':ic']='\\subset ', ['⊂']='\\subset ',
		[':ni']='\\subsetneq ', ['⊄']='\\subsetneq '
		}
local TSubstOperateurTW = {	['<=>']='⟺', 
		['<=']='⩽',
		['>=']='⩾',
		['<>']='≠',
		[':en']='≈',
		[':ap']='∈',
		[':as']='⟼',
		['->']='⟶',
		[':un']='∪',
		[':it']='∩',
		[':ro']='∘',
		[':eq']='~',
		[':co']='≡',
		[':pp']='∨',
		[':pg']='∧', [':ve']='∧',
		[':pe']='⊥',
		[':sd']='⊕',
		[':np']='∉',
		[':im']='⇒',
		[':ev']='⟺',
		[':rc']='⇐',
		[':ic']='⊂',
		[':ni']='⊄'
		}	
						  					  
local Chiffre=R("09")
local Partie_Entiere=Chiffre^1
local Partie_Decimale=(P(".")/",")*(Chiffre^1)
local Nombre = C(Partie_Entiere*Partie_Decimale^-1) * Espace
local Raccourci = 	C((P':al'+P'α')
		+ 	(P':be'+P'β')
		+	(P':ga'+P'γ') + (P':GA'+P'Γ')
		+	(P':de'+P'δ') + (P':DE'+P'Δ')
		+	(P':ep'+P'ε')
		+ 	(P':ze'+P'ζ')
		+ 	(P':et'+P'η')
		+	(P':th'+P'θ') +	(P':TH'+P'Θ')
		+	(P':io'+P'ι')
		+ 	(P':ka'+P'κ')
		+ 	(P':la'+P'λ') + (P':LA'+P'Λ')
		+ 	(P':mu'+P'μ')
		+	(P':nu'+P'ν')
		+ 	(P':xi'+P'ξ') +	(P':Xi'+P'Ξ')
		+ 	(P':pi'+P'π') + (P':PI'+P'Π')
		+ 	(P':rh'+P'ρ')
		+	(P':si'+P'σ') +	(P':SI'+P'Σ')
		+ 	(P':ta'+P'τ')
		+	(P':up'+P'υ') + (P':UP'+P'Υ')
		+ 	(P':ph'+P'φ') + (P':PH'+P'Φ')
		+	(P':ch'+P'χ') 
		+ 	(P':ps'+P'ψ') + (P':PS'+P'Ψ')
		+	(P':om'+P'ω') + (P':OM'+P'Ω')
		+	(P':in'+P'∞')
		+	(P':ll'+P'ℓ')
		+	(P':pm'+P'±')
		+	(P':dr'+P'∂')
		+	(P':vi'+P'∅')
		+	(P':ex'+P'∃')
		+	(P':qs'+P'∀')
		+	P':oijk'
		+	P':oij'
		+	P':ouv'
		+	(P':Rpe'+P'ℝpe')
		+	(P':Rme'+P'ℝme')
		+	(P':Rp'+P'ℝp')
		+	(P':Rm'+P'ℝm')
		+	(P':Re'+P'ℝe')
		+	(P':R'+P'ℝ')
		+	(P':Ne'+P'ℕe')
		+	(P':N'+P'ℕ')
		+	(P':Ze'+P'ℤe')
		+	(P':Z'+P'ℤ')
		+	(P':Ce'+P'ℂe')
		+	(P':C'+P'ℂ')
		+	(P':Qe'+P'ℚe')
		+	(P':Q'+P'ℚ')
		+	(P':K'+P'𝕂')
		+	(P':e'+P'е')
		+	(P':i'+P'і')
		+	P':d'
		- 	Operateur) * Espace

local TSubstRaccourciLaTeX = {	[':al']='\\alpha ', ['α']='\\alpha ',
		[':be']='\\beta ', ['β']='\\beta ',
		[':ga']='\\gamma ', ['γ']='\\gamma ', [':GA']='\\Gamma ', ['Γ']='\\Gamma ', 
		[':de']='\\delta ', ['δ']='\\delta ',[':DE']='\\Delta ', ['Δ']='\\Delta ',
		[':ep']='\\varepsilon ', ['ε']='\\varepsilon ',
		[':ze']='\\zeta ', ['ζ']='\\zeta ',
		[':et']='\\eta ', ['η']='\\eta ',
		[':th']='\\theta ', ['θ']='\\theta ',[':TH']='\\Theta ', ['Θ']='\\Theta ',
		[':io']='\\iota ', ['ι']='\\iota ',
		[':ka']='\\varkappa ', ['κ']='\\varkappa ',
		[':la']='\\lambda ', ['λ']='\\lambda ',[':LA']='\\Lambda ', ['Λ']='\\Lambda ',
		[':mu']='\\mu ', ['μ']='\\mu ',
		[':nu']='\\nu ', ['ν']='\\nu ',
		[':xi']='\\xi ', ['ξ']='\\xi ',[':Xi']='\\Xi ', ['Ξ']='\\Xi ',
		[':pi']='\\pi ', ['π']='\\pi ',[':PI']='\\Pi ', ['Π']='\\Pi ',
		[':rh']='\\rho ', ['ρ']='\\rho ',
		[':si']='\\sigma ', ['σ']='\\sigma ',[':SI']='\\Sigma ', ['Σ']='\\Sigma ',
		[':ta']='\\tau ', ['τ']='\\tau ',
		[':up']='\\upsilon ', ['υ']='\\upsilon ',[':UP']='\\Upsilon ', ['Υ']='\\Upsilon ',
		[':ph']='\\varphi ', ['φ']='\\varphi ',[':PH']='\\Phi ', ['Φ']='\\Phi ',
		[':ch']='\\chi ', ['χ']='\\chi ',
		[':ps']='\\psi ', ['ψ']='\\psi ',[':PS']='\\Psi ', ['Ψ']='\\Psi ',
		[':om']='\\omega ', ['ω']='\\omega ',[':OM']='\\Omega ', ['Ω']='\\Omega ',
		[':in']='\\infty ', ['∞']='\\infty ',
		[':ll']='\\ell ', ['ℓ']='\\ell ',
		[':pm']='\\pm ', ['±']='\\pm ',
		[':dr']='\\partial ', ['∂']='\\partial ',
		[':vi']='\\varnothing ', ['∅']='\\varnothing ',
		[':ex']='\\exists ', ['∃']='\\exists ',
		[':qs']='\\forall ', ['∀']='\\forall ',
		[':oijk']='\\left(O\\,{;}\\,\\vv{\\imath}{,}\\,\\vv{\\jmath}\\,\\vv{k} \\right) ',
		[':oij']='\\left(O\\,{;}\\,\\vv{\\imath}{,}\\,\\vv{\\jmath} \\right) ',
		[':ouv']='\\left(O\\,{;}\\,\\vv{u}{,}\\,\\vv{v} \\right) ',
		[':Rpe']='\\mathbb{R}_{+}^{*} ', ['ℝpe']='\\mathbb{R}_{+}^{*} ',
		[':Rme']='\\mathbb{R}_{-}^{*} ', ['ℝme']='\\mathbb{R}_{-}^{*} ',
		[':Rp']='\\mathbb{R}^{+} ', ['ℝp']='\\mathbb{R}^{+} ',
		[':Rm']='\\mathbb{R}^{-} ', ['ℝm']='\\mathbb{R}^{-} ',
		[':Re']='\\mathbb{R}^{*} ', ['ℝe']='\\mathbb{R}^{*} ',
		[':R']='\\mathbb{R} ', ['ℝ']='\\mathbb{R} ',
		[':Ne']='\\mathbb{N}^{*} ', ['ℕe']='\\mathbb{N}^{*} ',
		[':N']='\\mathbb{N} ', ['ℕ']='\\mathbb{N} ',
		[':Ze']='\\mathbb{Z}^{*} ', ['ℤe']='\\mathbb{Z}^{*} ',
		[':Z']='\\mathbb{Z} ', ['ℤ']='\\mathbb{Z} ',
		[':Ce']='\\mathbb{C}^{*} ', ['ℂe']='\\mathbb{C}^{*} ',
		[':C']='\\mathbb{C} ', ['ℂ']='\\mathbb{C} ',
		[':Qe']='\\mathbb{Q}^{*} ', ['ℚe']='\\mathbb{Q}^{*} ',
		[':Q']='\\mathbb{Q} ', ['ℚ']='\\mathbb{Q} ',
		[':K']='\\mathbb{K} ', ['𝕂']='\\mathbb{K} ',
		[':e']='\\mathrm{e} ', ['е']='\\mathrm{e} ',
		[':i']='\\ ', ['і']='\\mathrm{i} ',
		[':d']='{\\mathop{}\\mathopen{}\\mathrm{d}}'
		}

local TSubstRaccourciTW = {	[':al']='α',
		[':be']='β',
		[':ga']='γ', [':GA']='Γ', 
		[':de']='δ', [':DE']='Δ',
		[':ep']='ε',
		[':ze']='ζ',
		[':et']='η',
		[':th']='θ', [':TH']='Θ',
		[':io']='ι',
		[':ka']='κ',
		[':la']='λ',[':LA']='Λ',
		[':mu']='μ',   
		[':nu']='ν',
		[':xi']='ξ',[':Xi']='Ξ',
		[':pi']='π',[':PI']='Π',
		[':rh']='ρ',
		[':si']='σ',[':SI']='Σ',
		[':ta']='τ',
		[':up']='υ',[':UP']='Υ',
		[':ph']='φ',[':PH']='Φ',
		[':ch']='χ',
		[':ps']='ψ',[':PS']='Ψ',
		[':om']='ω',[':OM']='Ω',
		[':in']='∞',
		[':ll']='ℓ',
		[':pm']='±',
		[':dr']='∂',
		[':vi']='∅',
		[':ex']='∃',
		[':qs']='∀',
		[':Rpe']='ℝpe',
		[':Rme']='ℝme',
		[':Rp']='ℝp',
		[':Rm']='ℝm',
		[':Re']='ℝe',
		[':R']='ℝ',
		[':Ne']='ℕe',
		[':N']='ℕ',
		[':Ze']='ℤe',
		[':Z']='ℤ',
		[':Ce']='ℂe',
		[':C']='ℂ',
		[':Qe']='ℚe',
		[':Q']='ℚ',
		[':K']='𝕂',
		[':e']='е',
		[':i']='і'
		}

local Lettre = R("az")+R("AZ")+P("'")+P("!")					
local Mot=C(Lettre^1+P('∭')+P('∬')+P('∫')+P('√')) - Guillemet
local Op_LaTeX = C(P("\\")*Lettre^1) * Espace
local TermOp = C(S("+-")) * Espace
local FactorOp = C(P("**")+S("* ")+P("×")+P("..")) * Espace
local DiviseOp = C(P("//")+P("/")+P("÷")) * Espace
local PuissanceOp = C(S("^")) * Espace
local IndiceOp = C(S("_")) * Espace
local Parenthese_Ouverte = P("(") * Espace
local Parenthese_Fermee = P(")") * Espace
local Accolade_Ouverte = P("{") * Espace
local Accolade_Fermee = P("}") * Espace
local Crochet = C(S("[]")) * Espace
local Intervalle_Entier_Ouvert = P("[[")+P("⟦")
local Intervalle_Entier_Ferme = P("]]")+P("⟧")
local Fonction_sans_eval = P("xcas")+P("TVP")+P("TV")+P("TS")
local CaractereSansParentheses=(1-S"()")

-- Substitutions 
local TSubstCmath =		P'arcsin'/'\\arcsin '
		+	P'arccos'/'\\arccos '
		+	P'arctan'/'\\arctan '
		+	P'argch'/'\\argch '
		+	P'argsh'/'\\argsh '
		+	P'argth'/'\\argth '
		+	P'ppcm'/'\\ppcm '
		+	P'vect'/'\\vect '
		+	P'pgcd'/'\\pgcd '
		+	P'sin'/'\\sin '
		+	P'cos'/'\\cos '
		+	P'tan'/'\\tan '
		+	P'exp'/'\\exp '
		+	P'ima'/'\\Ima '
		+	P'arg'/'\\arg '
		+	P'ker'/'\\Ker '
		+	P'dim'/'\\dim '
		+	P'deg'/'\\deg '
		+	P'log'/'\\log '
		+	P'inf'/'\\inf '
		+	P'ln'/'\\ln '
		+	P'ch'/'\\ch '
		+	P'sh'/'\\sh '
		+	P'th'/'\\th '
		+	P'card'/'\\card '
		+	1

function fOperateur(arg1,op,arg2)
	return {'op_binaire',op,arg1,arg2}
end


function fTerm(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fParentheses(arg1)
	return {'()',arg1}
end

function fAccolades(arg1)
	return {'{}',arg1}
end

function fIndice(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fFactor(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fDivise(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fPuissance(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fMultImplicite(arg1,arg2)
	if string.sub(arg1[1],1,5)=='signe' then
		return {arg1[1],{'imp*',arg1[2],arg2}}
	else
		return {'imp*',arg1,arg2}
	end
end

function fTexte(arg1)
	return {'text',arg1}
end

function fFonction_sans_eval(arg1,arg2)
	return {'no_eval',arg1,arg2}
end



function fListe(arg1,op,arg2)
	if arg2==nil then arg2={''} end
	if arg1[1]=='liste '..op then
		table.insert(arg1,arg2)
		return arg1
	else
		--print(arg1..op)
		if arg1=='' then arg1={''} end
		return {'liste '..op,arg1,arg2}
	end
end

function fSans_texte(arg1)
	return {arg1}
end

function fOp_LaTeX(arg1)
	return {'latex',arg1}
end

function fCrochets(arg1,arg2,arg3)
	return {arg1,arg2,arg3}
end

function fRaccourcis(arg1)
	return {'raccourci',arg1} --match(Cs(Raccourci),arg1)
end

function fFormule_signee(arg1,arg2)
   return {'signe '..arg1,arg2}
end


function fIntervalle_Entier(arg1)
	return {'⟦⟧',arg1}
end


local FonctionsCmath = 	P('abs')+ 			-- valeur absolue
		P('iiint')+P('∭')+	-- intégrale triple
		P('iint')+P('∬')+	-- intégrale double
		P('int')+P('∫')+	-- intégrale
		P('rac')+P('√')+	-- racine
		P('vec')+			-- vecteur ou coordonnées de vecteurs si liste
		P('cal')+P('scr')+P('frak')+P('pzc')+ -- polices
		P('ang')+
		P('til')+
		P('bar')+
		P('sou')+
		P('nor')+
		P('acc')+
		P('som')+
		P('pro')+
		P('uni')+
		P('ite')+
		P('psc')+
		P('acs')+
		P('aci')+
		P('cnp')+
		P('aut')+
		P('bif')+
		P('sys')+
		P('mat')+
		P('det')+
		P('tab')+
		P('tor')+
		P('cro')+
		P('ds')+
		P('ts')+
		P('im')+
		P('re')
												
function construitMatrix(arbre,typeMatrice)
local s='\\begin{'..typeMatrice..'}\n'
local n = nbArg(arbre)
local nb_col = tonumber(Tree2Latex(arbre[1]))
for i=2,n-1 do 
	s=s..Tree2Latex(arbre[i])
	if (i-1)%nb_col==0 then
		s=s..' \\\\\n'
	else
		s=s..' & '
	end
end
s=s..Tree2Latex(arbre[n])..'\n\\end{'..typeMatrice..'}'
return s
end

local TraitementFonctionsCmath = 
{ 	['abs']=
	function(arbre) 
		return '\\left\\vert{'..Tree2Latex(arbre)..'} \\right\\vert ' 
	end,

	['vec']=
	function(arbre) 
		return '\\vv{'..Tree2Latex(arbre)..'}' 
	end,
	
	['rac']=
	function(arbre)
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
      local n = nbArg(arbre)
			return '\\sqrt['..Tree2Latex(arbre[1])..']{'..Tree2Latex(arbre[2])..'}'
		else
			return '\\sqrt{'..Tree2Latex(arbre)..'}'
		end
	end,
	
	['√']=
	function(arbre)
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
      local n = nbArg(arbre)
			return '\\sqrt['..Tree2Latex(arbre[1])..']{'..Tree2Latex(arbre[2])..'}'
		else
			return '\\sqrt{'..Tree2Latex(arbre)..'}'
		end
	end,
	
	['int']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\int _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n==4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
		end
		s=s..'}'
		return s
	end,
	
	['∫']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\int _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n==4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
		end
		s=s..'}'
		return s
	end,

	['iint']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
		end
		s=s..'}'
		return s
	end,
	
	['∬']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
		end
		s=s..'}'
		return s
	end,

	['iiint']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iiint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[6])
		end
		s=s..'}'
		return s
	end,
	
	['∭']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iiint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[6])
		end
		s=s..'}'
		return s
	end,

	['cal']=
	function(arbre) 
		return '\\mathcal{'..Tree2Latex(arbre)..'}' 
	end,
	
	['scr']=
	function(arbre) 
		return '\\mathscr{'..Tree2Latex(arbre)..'}' 
	end,
	
	['frak']=
	function(arbre) 
		return '\\mathfrak{'..Tree2Latex(arbre)..'}' 
	end,
	
	['pzc']=
	function(arbre) 
		return '\\mathpzc{'..Tree2Latex(arbre)..'}' 
	end,
	
	['ang']=
	function(arbre) 
		return '\\widehat{'..Tree2Latex(arbre)..'}' 
	end,

	['til']=
	function(arbre) 
		return '\\widetilde{'..Tree2Latex(arbre)..'}' 
	end,

	['bar']=
	function(arbre) 
		return '\\overline{'..Tree2Latex(arbre)..'}' 
	end,

	['sou']=
	function(arbre) 
		return '\\underline{'..Tree2Latex(arbre)..'}' 
	end,

	['nor']=
	function(arbre) 
		return '\\lVert{'..Tree2Latex(arbre)..'}\\rVert' 
	end,

	['acc']=
	function(arbre) 
		return '\\left\\{ '..Tree2Latex(arbre)..'\\right\\} ' 
	end,
	
	['som']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\sum _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['pro']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\prod _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['ite']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\bigcap _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['uni']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\bigcup _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['psc']=
	function(arbre)
		return '\\left\\langle '..Tree2Latex(arbre)..'\\right\\rangle '
	end,
	
	['acs']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\overbrace{'..Tree2Latex(arbre[1])..'}^{'..Tree2Latex(arbre[2])..'}'
	end,

	['aci']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\underbrace{'..Tree2Latex(arbre[1])..'}_{'..Tree2Latex(arbre[2])..'}'
	end,

	['cnp']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\binom{'..Tree2Latex(arbre[1])..'}{'..Tree2Latex(arbre[2])..'}'
	end,
	
	['aut']=
	function(arbre)
		local n = nbArg(arbre)
		for i=n+1,5 do arbre[i]={''} end
		return '\\prescript{'..Tree2Latex(arbre[4])..'}{'..Tree2Latex(arbre[5])..'}{'..Tree2Latex(arbre[1])..'}_{'..Tree2Latex(arbre[2])..'}^{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['bif']=
	function(arbre) 
		return '\\cancel{ '..Tree2Latex(arbre)..'} ' 
	end,
	
	['sys']=
	function(arbre)
		local s='\\begin{cases}\n'
		local n = nbArg(arbre)
		s=s..Tree2Latex(arbre[1])
		for i=2,n do 
			s=s..' \\\\\n'..Tree2Latex(arbre[i])
		end	
		s=s..'\n\\end{cases}'
		return s
	end,
	
	['mat']=
	function(arbre)
		return construitMatrix(arbre,"pmatrix")
	end,

	['det']=
	function(arbre)
		return construitMatrix(arbre,"vmatrix")
	end,

	['tab']=
	function(arbre)
		return construitMatrix(arbre,"matrix")
	end,

	['tor']=
	function(arbre)
		return construitMatrix(arbre,"Bmatrix")
	end,

	['cro']=
	function(arbre)
		return construitMatrix(arbre,"bmatrix")
	end,
	
	['im']=
	function(arbre) 
		return '\\Im{'..Tree2Latex(arbre)..'}' 
	end,

	['re']=
	function(arbre) 
		return '\\Re{'..Tree2Latex(arbre)..'}' 
	end,

	['ts']=
	function(arbre) 
		return '{\\textstyle '..Tree2Latex(arbre)..'} ' 
	end,
	
	['ds']=
	function(arbre) 
		return '{\\displaystyle '..Tree2Latex(arbre)..'} ' 
	end
}

function nbArg(liste)
	table.remove(liste,1)
	return #liste
end

function Parentheses_inutiles(Arbre)
	if Arbre[1]=='()' then
		return Arbre[2]
	else
		return Arbre
	end
end

function fCommandes(arg1,arg2,arg3)
	return arg1..','..arg2
end

function fExpressionsXcas(arg1,arg2,arg3) --arg3 à supprimer
	return string.sub(arg1,1,arg1:len()-1)..string.sub(arg2,2)
end

function fFacteursXcas(arg1,arg2) --arg2 à supprimer
	return '"'..arg1..'"'
end


-- Grammaire Commandes Xcas
local Commandes, ExpressionsXcas, FacteursXcas = V"Commandes", V"ExpressionsXcas", V"FacteursXcas"
local CommandesXcas = P { Commandes,
  Commandes = Cf(ExpressionsXcas * Cg(P(",") * ExpressionsXcas)^0,fCommandes),
  ExpressionsXcas = Cf(FacteursXcas *Cg(FacteursXcas )^0,fExpressionsXcas),
  FacteursXcas = C((1-S'()[]{},')^1+V'ExpressionsXcasParentheses'+V'ExpressionsXcasAccolades'+V'ExpressionsXcasCrochets')/fFacteursXcas,
  ExpressionsXcasParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
  ExpressionsXcasAccolades=P{'{'*((1-S('{}'))+V(1))^0*'}'},
  ExpressionsXcasCrochets=P{'['*((1-S('[]'))+V(1))^0*']'}
}


function Tree2Latex(Arbre)
local op=Arbre[1]
local arg1, arg2 = '',''
if op=='' then return '' end
if (op=='op_binaire') then
	return Tree2Latex(Arbre[3])..TSubstOperateurLaTeX[Arbre[2]]..Tree2Latex(Arbre[4])
elseif (op=='+' or op=='-') then
	return Tree2Latex(Arbre[2])..op..Tree2Latex(Arbre[3])
elseif (op=='*' or op==' ') then
	return Tree2Latex(Arbre[2])..' '..Tree2Latex(Arbre[3])
elseif (op=='×' or op=='**') then
	return Tree2Latex(Arbre[2])..'\\times '..Tree2Latex(Arbre[3])
elseif (op=='..') then
	return Tree2Latex(Arbre[2])..'\\cdot '..Tree2Latex(Arbre[3])
elseif (op=='//' or op=='÷') then
	return Tree2Latex(Arbre[2])..'\\div '..Tree2Latex(Arbre[3])		
elseif (op=='imp*') then
	arg1=Tree2Latex(Arbre[2])
	-- recherche de fonctions cmath
	if arg1==match(C(FonctionsCmath),arg1) then
		return TraitementFonctionsCmath[arg1](Parentheses_inutiles(Arbre[3]))
	else
		return arg1..' '..Tree2Latex(Arbre[3])
	end
elseif (op=='()') then
	return '\\left( '..Tree2Latex(Arbre[2])..'\\right) '
elseif (op=='{}') then
	return '{'..Tree2Latex(Arbre[2])..'}'
elseif (op=='/') then
	return '\\frac{'..Tree2Latex(Parentheses_inutiles(Arbre[2]))..'}{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
elseif (op=='^' or op=='_') then
	return Tree2Latex(Arbre[2])..op..'{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
elseif (op=='text') then
	return '\\textrm{'..Arbre[2]..'}'
elseif (op=='no_eval') then
	if Arbre[2]=='xcas' then
		return Giac("",Arbre[3],"true")
	elseif Arbre[2]=='TV' then
		return Giac(XCAS_Tableaux,'TV('..Arbre[3]..')',"false")
	elseif Arbre[2]=='TS' then
		return Giac(XCAS_Tableaux,'TS('..Arbre[3]..')',"false")	
	elseif Arbre[2]=='TVP' then
		return Giac(XCAS_Tableaux,'TVP('..Arbre[3]..')',"false")
	else	
		return Arbre[2]..'("'..Arbre[3]..'")'
	end
elseif (op=='latex') then
	return Arbre[2]	
elseif (op=='liste ,' or op=='liste ;') then
	s=Tree2Latex(Arbre[2])
	sep='\\mathpunct{'..string.sub(op, -1)..'}'
	for key,value in next,Arbre,2 do s=s..sep..Tree2Latex(value) end
	return s
elseif (op=='[' or op==']') then
	return '\\left'..Arbre[1]..' '..Tree2Latex(Arbre[2])..' \\right'..Arbre[3]..' '
elseif (op=='⟦⟧') then
	return  '\\llbracket '..Tree2Latex(Arbre[2])..' \\rrbracket '
elseif (string.sub(op,1,5)=='signe') then
	return string.sub(op,7)..Tree2Latex(Arbre[2])
--elseif (match(Operateur,op)) then
--	return Tree2Latex(Arbre[2])..TSubstOperateur[op]..Tree2Latex(Arbre[3])
elseif (op=='raccourci') then
	return TSubstRaccourciLaTeX[Arbre[2]]
else
	-- Repérer les fonctions usuelles
	return match(Cs(TSubstCmath^1),op)
	-- return op
end
end


function Tree2TW(Arbre)
local op=Arbre[1]
local arg1, arg2 = '',''
if op=='' then return '' end
if (op=='op_binaire') then
	arg2=TSubstOperateurTW[Arbre[2]]
	if arg2==nil then arg2=Arbre[2] end
	return Tree2TW(Arbre[3])..arg2..Tree2TW(Arbre[4])
elseif (op=='×' or op=='**') then
	return Tree2TW(Arbre[2])..'×'..Tree2TW(Arbre[3])
elseif (op=='//' or op=='÷') then
	return Tree2TW(Arbre[2])..'÷'..Tree2TW(Arbre[3])		
elseif (op=='imp*') then
	if Arbre[2][1]=='iiint' then Arbre[2]={'∭'} end
	if Arbre[2][1]=='iint' then Arbre[2]={'∬'} end
	if Arbre[2][1]=='int' then Arbre[2]={'∫'} end
	if Arbre[2][1]=='rac' then Arbre[2]={'√'} end
	return Tree2TW(Arbre[2])..Tree2TW(Arbre[3])
elseif (op=='()') then
	return '('..Tree2TW(Arbre[2])..')'
elseif (op=='{}') then
	return '{'..Tree2TW(Arbre[2])..'}'
elseif (op=='^' or op=='_' or op=='/' or op=='..' or op=='+' or op=='-' or op=='*' or op==' ') then
	return Tree2TW(Arbre[2])..op..Tree2TW((Arbre[3]))
elseif (op=='text') then
	return Arbre[2]
elseif (op=='no_eval') then
		return Arbre[2]..'('..Arbre[3]..')'
elseif (op=='latex') then
	return Arbre[2]	
elseif (op=='liste ,' or op=='liste ;') then
	s=Tree2TW(Arbre[2])
	sep=string.sub(op, -1)
	for key,value in next,Arbre,2 do s=s..sep..Tree2TW(value) end
	return s
elseif (op=='[' or op==']') then
	return Arbre[1]..Tree2TW(Arbre[2])..Arbre[3]
elseif (op=='⟦⟧') then
	return  '⟦'..Tree2TW(Arbre[2])..'⟧'
elseif (string.sub(op,1,5)=='signe') then
	return string.sub(op,7)..Tree2TW(Arbre[2])
--elseif (match(Operateur,op)) then
--	return Tree2Latex(Arbre[2])..TSubstOperateur[op]..Tree2Latex(Arbre[3])
elseif (op=='raccourci') then
	arg2=TSubstRaccourciTW[Arbre[2]]
	if arg2==nil then arg2=Arbre[2] end
	return arg2
else
	--return match(Cs(TSubstCmath^1),op)
	return op
end
end

function Giac(programme,instruction,latex)
-- exécute le programme sans conserver le retour
-- puis exécute l'instruction en renvoyant le résultat
-- conversion en latex selon le booléen latex (pas de conversion pour les tableaux de variations/signes)
local prg=[[
unarchive("giac.sav"):;
Sortie:=fopen("giac.out");
]]..programme..[[
purge(Resultat);
if(sommet(quote(]]..instruction..[[))=='sto'){
  ]]..instruction..[[;
  Resultat:='""'} else {
  Resultat:=(]]..instruction..[[)};
if(Resultat=='Resultat'){
  Resultat:="Erreur Xcas"};
if(]]..latex..[[){
  fprint(Sortie,Unquoted,latex(Resultat));
} else {
  fprint(Sortie,Unquoted,Resultat);
};
fclose(Sortie);
archive("giac.sav"):;
]]
local f,err = io.open("giac.in","w")
if not f then return print(err) end
f:write(prg)
f:close()
if QuelOs()=='linux' then
	os.execute("icas giac.in")
else --windows, à modifier pour identifier un Mac
	os.execute("c:\\xcas\\rxvt.exe c:/xcas/icas.exe giac.in")
end
io.input("giac.out")
return(io.read("*all"))
end


function QuelOs()
local conf=package.config
if string.sub(conf,1,1)=='/' then 
	return 'linux'
else
	return 'win'
end
end


-- Pour debug --
function taille(t)
	if type(t)=='table' then
		return taille(t[1])
	else
		return string.len(t)
	end
end

function AfficheArbre(t,n)    
   for key,value in pairs(t) do
	   if type(t[key])=='table' then
			write(" {")
			AfficheArbre(t[key],n+taille(t[key][1])+1)
			write("}\n")
			for i=1,n+1 do write (" ") end
	   else 
			write(""..value.."")
			n=n+1
	   end
   end
end

-- Grammaire Cmath
local Argument, Membre, Expression, Term, Facteur, Exposant, Indice, MultImplicite, Formule, Formule_signee = V"Argument", V"Membre", V"Expression", V"Term", V"Facteur", V"Exposant", V"Indice", V"MultImplicite", V"Formule", V"Formule_signee"
Cmath2Tree = P { Argument,
  Argument = Cf((Membre * Cg(SepListe * Membre^0)^0)+(Cc('')*Cg(SepListe*Membre)^1)+(Cc('')*Cg(SepListe*Membre^0)^1), fListe),
  Membre = Cf(Expression * Cg(Operateur * Expression)^0, fOperateur),
  Expression = Cf(Term * Cg(TermOp * Term)^0,fTerm),
  Term = Cf(Facteur * Cg(FactorOp * Facteur)^0,fFactor),
  Facteur = Cf(Exposant * Cg(DiviseOp * Exposant)^0,fDivise),
  Exposant = Cf(Indice * Cg(PuissanceOp * Indice)^0,fPuissance),
  Indice = Cf(MultImplicite * Cg(IndiceOp * MultImplicite)^0,fIndice),
  MultImplicite= Cf((Formule_signee+Formule-Fonction_sans_eval) * Cg(Formule-Formule_signee)^0 ,fMultImplicite)+(C(Fonction_sans_eval)*Parenthese_Ouverte*C((V'ExpressionSansEval')^1)*Parenthese_Fermee)/fFonction_sans_eval,
  Formule_signee=(C(S('+-'))*Cg(Formule))/fFormule_signee,
  Formule=V'texte' + V'sans_texte' + V'parentheses' + V'accolades' + V'intervalle_entiers' + V'crochets',
  texte = Guillemet*C((1-Guillemet)^0)/fTexte*Guillemet,
  ExpressionSansEvalParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
  ExpressionSansEval=CaractereSansParentheses^1+V'ExpressionSansEvalParentheses',
  sans_texte=((Nombre+Mot)/fSans_texte+Op_LaTeX/fOp_LaTeX+Raccourci/fRaccourcis),
  parentheses=Parenthese_Ouverte*(Argument/fParentheses)*Parenthese_Fermee,
  accolades=Accolade_Ouverte*(Argument/fAccolades)*Accolade_Fermee,
  intervalle_entiers=(Intervalle_Entier_Ouvert*Argument*Intervalle_Entier_Ferme)/fIntervalle_Entier,
  crochets=(Crochet*Argument*Crochet)/fCrochets
}

-- Fonction appelée depuis LuaTeX
function Cmath2LaTeX(formule)
	-- Construction de l'arbre de la formule
	Arbre=match(Cmath2Tree,formule)
	if not Arbre then 
		return("Erreur de syntaxe : ".. formule)
	else
		-- Construction de la formule
		Formule=Tree2Latex(Arbre)
		-- tex.print n'accepte qu'une seule ligne
		Formule=string.gsub(Formule, "\n", " ")
		return(Formule)
	end
end

-- Fonction appelée depuis TexWorks (F9 et Shift+F9)
function Cmath2TW(formule)
	-- Construction de l'arbre de la formule
	Arbre=match(Cmath2Tree,formule)
	if not Arbre then 
		return("Erreur de syntaxe : ".. formule)
	else
		-- Construction de la formule
		return(Tree2TW(Arbre))
	end
end

-- Fonction appelée depuis TexWorks (Ctrl+F9 et Shift+Ctrl+F9)
function Cmath2LaTeXinTW(formule)
	-- Construction de l'arbre de la formule
	Arbre=match(Cmath2Tree,formule)
	if not Arbre then 
		return("Erreur de syntaxe : ".. formule)
	else
		-- Construction de la formule
		Formule=Tree2Latex(Arbre)
		return(Formule)
	end
end

XCAS_Tableaux=[[
initCas():={
  complex_mode:=0;
  complex_variables:=0;
  angle_radian:=1;
  all_trig_solutions:=1;
  reset_solve_counter(-1,-1);
  with_sqrt(1);
}:;

trigo(expression):={
// renvoie vrai si l'expression dépend d'un paramètre n_1 (solutions d'une équation trigo dans xcas)  
  if (subst(expression,n_1=0)==expression)
    return faux;
  else
    return vrai;
}:;

debutTableau(colonne,hauteurLigne,valX):={
// colonne est la liste des lignes de la première colonne
// hauteurLigne est la liste des hauteurs des lignes
// valX est la liste des valeurs de x à inscrire dans la première ligne
// renvoie la chaine définissant la première partie du tableau  
  local k,s;
  s:="\\begin{tikzpicture}\n";
  s:=s+"\\tkzTabInit[lgt=2,espcl=2,deltacl=0.5]\n";
  s:=s+"{";
  for(k:=0;k<size(colonne);k++){
    if (k>0){s:=s+","};
    s:=s+colonne[k]+" / "+hauteurLigne[k];
  }  
  s:=s+"}\n{";
  for(k:=0;k<size(valX);k++){
    if (k>0){s:=s+","};
    s:=s+"$"+latex(valX[k])+"$";
  }
  s:=s+"}\n";
  return(s);
}:;

trouveVI(IE,f):={
  local k,s,o,n,listeVI:=[];
  s:=sommet(f);
  o:=op(f);
  if (s=='inv') {
    return(solve(o=0,x));
  } else {
  if (s=='*'){
    n:=size(o);
    for(k:=0;k<n;k++)
        listeVI:=concat(listeVI,trouveVI(IE,o[k]));
    return(Elague(IE,listeVI));
  } else {
  if (s=='^'){
    if(evalf(abs(o[1])<1)){
      return(Elague(IE,solve(o[0]=0,x)))
    } else {
      return([]);
    }
  } else {
  if (s=='ln'){
    return(Elague(IE,solve(o=0,x)));
  } else {
  if (s=='id'){
      return([]);
  } else {
  if (type(o)==DOM_LIST){
    for(k:=0;k<size(o);k++)
        listeVI:=concat(listeVI,trouveVI(IE,o[k]));
    return(Elague(IE,listeVI));}
  else {
    return(trouveVI(IE,o));
  }
  }}}}}
}:;

Elague(IE,liste):={
  local nliste,nIE,k,listeelaguee,expression,m,mini,maxi;
  listeelaguee:=[];
  nliste:=size(liste);
  nIE:=size(IE);
  mini:=IE[0];maxi:=IE[nIE-1];
  for(k:=0;k<nliste;k++){
    expression:=liste[k];
    if (trigo(expression)) {
      m:=0;
      while(subst(expression,n_1=m)<=maxi) {
        listeelaguee:=concat(listeelaguee,simplify(subst(expression,n_1=m)));
        m:=m+1;
      };
      m:=-1;
      while(subst(expression,n_1=m)>=mini) {
        listeelaguee:=concat(listeelaguee,simplify(subst(expression,n_1=m)));
        m:=m-1;
      }
    } else {
      if(expression>mini and expression<maxi){
        listeelaguee:=concat(listeelaguee,expression);
      }
    }
    
  }
  return(sort(listeelaguee));
}:;

trouveZeros(IE,f):={
  local n:=size(IE);
  local Z,err;
  try {Z:=solve(factor(simplify(f(x)=0)),x);}
  catch(err){Z:=fsolve(f(x)=0,x,IE[0]..IE[n-1]);};
  Z:=Elague(IE,Z);  
  return(Z);
}:;

insereValeurs(l1,l2):={
  // insère les valeurs de l2 dans l1 puis trie
  // l2 est supposée appartenir à [min(l1),max(l1)] puisque l2 provient
  // de la fonction Elague qui ne garde que les valeurs dans IE
  local k,l:=l1;
  local n2:=size(l2);
  for(k:=0;k<n2;k++){
    if (not(member(l2[k],l1))){
        l:=append(l,l2[k]);        
        }
    }
  return(sort(l));
}:;

estDefinie(f,x):={
  local y;
  if (abs(x)==+infinity){return(faux)}
  y:=f(x);
  if (y==undef){return(faux)}
  if (abs(y)==+infinity){return(faux)}
  if (im(evalf(y))!=0){return(faux)}
  return(vrai);
}:;

tabSignes(IE,f,g):={
// f est la fonction dont on étudie le signe
// g est une fonction qui doit exister au point testé pour valider le signe
  local k,x,nIE,a,xi;
  local signes:=[];
  nIE:=size(IE);
  for(k:=0;k<=nIE-2;k++){
    if(estDefinie(f,IE[k]) and estDefinie(g,IE[k])){
      signes:=append(signes,simplifier(f(IE[k])));
      } else {
      if(abs(IE[k])==+infinity){
        signes:=append(signes," ");
      } else {
        signes:=append(signes,"d");
      }
    }
    xi:=x_milieu(IE[k],IE[k+1]);
    if(estDefinie(f,xi) and estDefinie(g,xi)){
      if(f(xi)>0){
        signes:=append(signes,"+");
      } else {
        signes:=append(signes,"-");
      }
    } else {
      signes:=append(signes,"h");
    }
  }
  if(estDefinie(f,IE[nIE-1]) and estDefinie(g,IE[nIE-1])){
    signes:=append(signes,simplifier(f(IE[nIE-1])));
    } else {
      if(abs(IE[nIE-1])==+infinity){
        signes:=append(signes," ");
      } else {
        signes:=append(signes,"d");
      }
    }
  return(signes);
}:;

calculeImages(IE,f):={
  local k;
  local images;
  local nIE:=size(IE);
  images:=[ [infinity,simplifier(limite(f(x),x,IE[0],1))] ];
  for(k:=1;k<=nIE-2;k++){
    images:=append(images,[simplifier(limite(f(x),x,IE[k],-1)),simplifier(limite(f(x),x,IE[k],1))]);
    }
  images:=append(images,[simplifier(limite(f(x),x,IE[nIE-1],-1)),infinity]);
  return(images);
}:;

calculePosition(IE,VI,f,images):={
  // crée une liste avec la position des images, les double-barres, les zones interdites.
  local k,sg,sd,symb,xi;
  local pos:=[];
  local sg:="";
  local nIE:=size(IE);
  for(k:=0;k<=nIE-2;k++){
    symb:=sg;
    if(member(IE[k],VI) or not(estDefinie(f,IE[k]))){
      // chercher prolongement par continuité
      if (abs(images[k][0])!=+infinity and images[k][0]==images[k][1]){
        symb:="R";        
      } else {
      if(abs(IE[k])!=+infinity){symb:=symb+"D";}
      xi:=x_milieu(IE[k],IE[k+1]);
      if(not(estDefinie(f,xi))){
        if (k==0){// impossible de mettre DH en première colonne
          symb:="-D"};
        symb:=symb+"H";sg:="";} else {
      if(images[k][1]<=images[k+1][0]){
        symb:=symb+"-";
        sg:="+";
      } else {
        symb:=symb+"+";    
        sg:="-";
      }}
      }
    } else {
      if(images[k][1]<=images[k+1][0]){
        symb:=symb+"-";
        sg:="+";        
      } else {
        symb:=symb+"+";
        sg:="-";
      }
      if(symb=="++"){symb:="+"}
      else {if(symb=="--"){symb:="-"}
        else {if(k>0){symb:="R"}}}}
    pos:=append(pos,symb);
  }    
  // dernier point
  symb:=sg;
  if(member(IE[nIE-1],VI) or not(estDefinie(f,IE[nIE-1]))){
      if(abs(IE[k])!=+infinity){
        symb:=symb+"D";
        if (sg==""){// impossible de mettre D
          symb:=symb+"+"};
      }
  }
  return(pos:=append(pos,symb));
}:;

noeudsNonExtrema(pos):={
  // renvoie une liste contenant les noeuds des images à calculer dans le tableau
  local k;
  local npos:=size(pos);
  local noeuds:=[0];
  for(k:=1;k<=npos-2;k++){
    if (pos[k]=="R"){
      local nmin,nmax;
      nmin:=k-1;
      nmax:=k+1;
      while(pos[nmin]=="R"){nmin--;}
      while(pos[nmax]=="R"){nmax++;}
      noeuds:=append(noeuds,[nmin+1,nmax+1,k+1]);
    } else {
      noeuds:=append(noeuds,0);
    }
  }
  noeuds:=append(noeuds,0);
}:;

ligneSignes(signes):={
  local n,sTkzTabLine,j,k;
  
  n:=size(signes);

sTkzTabLine:="\\tkzTabLine {";
for(k:=0;k<n;k++){
  j:=type(signes[k]);
  if(type(signes[k])==12){ //DOM_STRING bug
    sTkzTabLine+=signes[k];    
    } else {
    if (signes[k]==0){
      sTkzTabLine+="z";
      } else {
      sTkzTabLine+="t";      
      }
    }
    if (k<n-1){
      sTkzTabLine+=",";
    }
  }
  sTkzTabLine+="}\n";
  return(sTkzTabLine);
}:;



ligneVariations(positions,images):={
local n,sTkzTabVar,pos,k;
n:=size(positions);
sTkzTabVar:="\\tkzTabVar {";
for(k:=0;k<n;k++){
  pos:=positions[k];
  sTkzTabVar:=sTkzTabVar+pos;
  if (pos!="R"){
    if(pos=="+" or pos=="-"){
      if(k==0){
        sTkzTabVar:=sTkzTabVar+" / $"+latex(images[0][1])+"$";        
      } else {
        sTkzTabVar:=sTkzTabVar+" / $"+latex(images[k][0])+"$";      
      }
    } else {
    if(left(pos,1)=="-" or left(pos,1)=="+"){
      if(k==0){
        sTkzTabVar:=sTkzTabVar+"/ ";        
      } else {
       sTkzTabVar:=sTkzTabVar+" / $"+latex(images[k][0])+"$";      
      }
    };
    if(right(pos,1)=="-" or right(pos,1)=="+"){
      if(k==n-1){
        sTkzTabVar:=sTkzTabVar+"/ ";        
      } else {
        sTkzTabVar:=sTkzTabVar+" / $"+latex(images[k][1])+"$";      
      }
    }
  }   
  };
  if (k<n-1){
    sTkzTabVar+=",";
  }
}
sTkzTabVar+="}\n";
return(sTkzTabVar);
}:;


lignesImages(noeuds,images):={
  local k,n;
  local sTkzTabIma:="";
  n:=size(noeuds);
  for(k:=0;k<n;k++){
    if(size(noeuds[k])==3){
      sTkzTabIma:=sTkzTabIma+"\\tkzTabIma{"+noeuds[k][0]+"}";
      sTkzTabIma:=sTkzTabIma+"{"+noeuds[k][1]+"}";
      sTkzTabIma:=sTkzTabIma+"{"+noeuds[k][2]+"}";
      sTkzTabIma:=sTkzTabIma+"{$"+latex(images[k][0])+"$}\n";
    }
  }
  return(sTkzTabIma);
}:;

x_milieu(x1,x2):={
  if(x1==-infinity and abs(x2)==+infinity){return(0)};
  if(x1==-infinity){return(x2-1)}
  if(abs(x2)==+infinity){return(x1+1)}  
  return((x1+x2)/2);
}:;

sontDefinies(f,liste_zeros):={
  local k,n,liste:=[];
  n:=size(liste_zeros);
  for(k:=0;k<n;k++){
    if(estDefinie(f,liste_zeros[k])){
      liste:=append(liste,liste_zeros[k]);
    }
  }
  return(liste);
}:;

identifier(expression):={
  //renvoie [fonction, [nom variable,nom variable latex], [nom fonction, nom fonction latex],
  // [nom dérivée, nom dérivée latex] ] au format LaTeX
  local x,membres,g,d,fonc,var,commande;
  if (sommet(expression)=='='){
    membres:=op(expression);
    g:=membres[0];
    d:=membres[1];
    fonc:=op(g)[0];
    var:=op(g)[1];
    commande:="unapply(d,"+var+")";
    return([execute(commande),[var,latex(var)],[fonc,latex(fonc)],[fonc+"'",latex(fonc)+"'"] ]);
  } else {
  return([unapply(expression,x),["x","x"],["x->"+expression,"x\\mapsto "+latex(expression)],["(x->"+expression+")'","\\left( x\\mapsto "+latex(expression)+"\\right) '"] ])
  }
}:;

listeFacteurs(expression):={
  local k,s,o;
  local numerateur;
  local denominateur:=[];
  o:=[op(expression)];
  s:=sommet(expression);
  if (s=='*'){
    numerateur:=o;
  } else {
    numerateur:=[expression];
  }
  // extraire le dénominateur et regrouper les facteurs constants
  for(k:=0;k<size(numerateur);k++){
    if(sommet(numerateur[k])=='inv'){
      if(sommet(op(numerateur[k]))=='*'){
        denominateur:=append(denominateur,op(op(numerateur[k])));
      } else {
        denominateur:=append(denominateur,op(numerateur[k]));
      }
      //execute("numerateur:=subsop(numerateur,'"+string(k)+"=NULL')");
      numerateur:=suppress(numerateur,k);
      k--;
    };
    if(k<size(numerateur)-1){
      if(type(evalf(numerateur[k]))==DOM_FLOAT and sommet(numerateur[k+1])!='inv'){
        numerateur[k+1]:=numerateur[k]*numerateur[k+1];
        //execute("numerateur:=subsop(numerateur,"+string(k+1)+"="+string(numerateur[k]*numerateur[k+1])+")");
        //execute("numerateur:=subsop(numerateur,'"+string(k)+"=NULL')");
        numerateur:=suppress(numerateur,k);
        k--;
      }
    }
  };
  for(k:=0;k<size(denominateur);k++){
    if(type(evalf(denominateur[k]))==DOM_FLOAT){
      if(k<size(denominateur)-1){
        denominateur[k+1]:=denominateur[k]*denominateur[k+1];
        //execute("denominateur:=subsop(denominateur,"+string(k+1)+"="+string(denominateur[k]*denominateur[k+1])+")");
        //execute("denominateur:=subsop(denominateur,'"+string(k)+"=NULL')");
        denominateur:=suppress(denominateur,k);
        k--;
      }
    }
  };
  return(numerateur,denominateur);
}:;

ligneSignesTVP(signes):={
  local n,sTkzTabLine,j,k;
  
  n:=size(signes);

sTkzTabLine:="\\tkzTabLine {";
for(k:=0;k<n;k++){
  j:=type(signes[k]);
  if(type(signes[k])==12){ //DOM_STRING bug
    sTkzTabLine+=signes[k];    
    } else {
    if (signes[k]==0){
      sTkzTabLine+="z";
      } else {
      sTkzTabLine:=sTkzTabLine+latex(signes[k]);      
      }
    }
    if (k<n-1){
      sTkzTabLine+=",";
    }
  }
  sTkzTabLine+="}\n";
  return(sTkzTabLine);
}:;

TV(IE,f):={
// IE=intervalle d'étude
// f=fonction
local VI; // liste des valeurs interdites de f
local fp; // f'
local Zeros_fp; // liste des racines de f'
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes_fp; // liste des signes de f'
local sTkzTabLine; // ligne des signes de f'
local Variations_f; // liste des variations de f
local sTkzTabVar; // ligne des variations de f
local Images_f; // liste des images de f
local NoeudsNonExtrema_f; // liste des images de f qui ne sont pas des extrema
local sTkzTabIma; // lignes des images de f
local k,n,j;
local id_fonction, nom_variable, nom_fonction, nom_derivee;
local a;
initCas();
id_fonction:=identifier(f);
f:=id_fonction[0];
nom_variable:=id_fonction[1][1];
nom_fonction:=id_fonction[2][1];
nom_derivee:=id_fonction[3][1];
//unapply(f,x);
fp:=function_diff(f);
IE:=sort(IE);
VI:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI);
Zeros_fp:=trouveZeros(IE,fp);
Zeros_fp:=sontDefinies(f,Zeros_fp);
ValeursX:=insereValeurs(ValeursX,Zeros_fp);
ValeursX:=sort([op(set[op(ValeursX)])]);
ValeursX:=simplifier(ValeursX);
// construction de la structure du tableau
sTkzTab:=debutTableau(["$"+nom_variable+"$","$"+nom_derivee+"("+nom_variable+")"+"$","$"+nom_fonction+"$"],[1,1,2],ValeursX);
// construction du signe de f'
Signes_fp:=tabSignes(ValeursX,fp,f);
sTkzTabLine:=ligneSignes(Signes_fp);
sTkzTab+=sTkzTabLine;
// construction des variations de f
//sTkzTabVar:="\\tkzTabVar {"
Images_f:=calculeImages(ValeursX,f);
Variations_f:=calculePosition(ValeursX,VI,f,Images_f);
sTkzTabVar:=ligneVariations(Variations_f,Images_f);
sTkzTab+=sTkzTabVar;
// construction des images de f
NoeudsNonExtrema_f:=noeudsNonExtrema(Variations_f);
sTkzTabIma:=lignesImages(NoeudsNonExtrema_f,Images_f);
sTkzTab+=sTkzTabIma;
sTkzTab+="\\end{tikzpicture}\n";
return(sTkzTab);
}:;

TS(IE,f):={
// IE=intervalle d'étude
// f=fonction
local VI; // liste des valeurs interdites de f
local Zeros_f; // liste des racines de f
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes; // liste des signes des facteurs de f
local sTkzTabLine; // lignes des signes des facteurs de f
local Images_f; // liste des images de f
local facteur, facteurs; // de f
local colonne; // contenu de la première colonne
local hauteurs_lignes;
local id_fonction, nom_variable, nom_fonction;
local k;
local denominateur;

initCas();
id_fonction:=identifier(f);
f:=id_fonction[0];
nom_variable:=id_fonction[1][0];
nom_fonction:=id_fonction[2][0];
IE:=sort(IE);
VI:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI);
Zeros_f:=trouveZeros(IE,f);
ValeursX:=insereValeurs(ValeursX,Zeros_f);
ValeursX:=simplifier(ValeursX);
facteurs:=execute("listeFacteurs(f("+nom_variable+"))");
if (size(facteurs[1])>0){
  // il y a un dénominteur, augmenter la hauteur de la dernière ligne
  denominateur:=true;
} else {
  denominateur:=false;
}
facteurs:=op(facteurs[0]),op(facteurs[1]);
if (size(facteurs)==1){ facteurs:=NULL };
// construction de la structure du tableau
colonne:=append([nom_variable],facteurs);
if(type(nom_fonction)==12){ //DOM_STRING=12
  colonne:=append(colonne,"$"+latex(f(x))+"$");
} else {
  colonne:=append(colonne,"$"+id_fonction[2][1]+"("+id_fonction[1][1]+")$");
}
for(k:=0;k<size(colonne)-1;k++)
  colonne[k]:="$"+latex(colonne[k])+"$";
hauteurs_lignes:=makelist(1,1,size(colonne)-1);
if (denominateur){
  hauteurs_lignes:=append(hauteurs_lignes,2);
} else {
  hauteurs_lignes:=append(hauteurs_lignes,1);
}
sTkzTab:=debutTableau(colonne,hauteurs_lignes,ValeursX);
// construction du signe des facteurs
for(k:=0;k<size(facteurs);k++){
  facteur:=execute("unapply(facteurs[k],"+nom_variable+")");
  Signes:=tabSignes(ValeursX,facteur,x->1);
  sTkzTabLine:=ligneSignes(Signes);
  sTkzTab+=sTkzTabLine;
}
// construction du signe de f s'il y a au moins 2 facteurs
Signes:=tabSignes(ValeursX,f,x->1);
sTkzTabLine:=ligneSignes(Signes);
sTkzTab+=sTkzTabLine;
sTkzTab+="\\end{tikzpicture}\n";
return(sTkzTab);
}:;

TVP(IE,f,g):={
// IE=intervalle d'étude
// f=fonction
local VI_f; // liste des valeurs interdites de f
local VI_g; // liste des valeurs interdites de g
local fp; // f'
local gp; // g'
local Zeros_fp; // liste des racines de f'
local Zeros_gp; // liste des racines de g'
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes_fp; // liste des signes de f'
local Signes_gp; // liste des signes de g'
local Variations_f; // liste des variations de f
local Variations_g; // liste des variations de g
local Images_f; // liste des images de f
local Images_g; // liste des images de g
local NoeudsNonExtrema_f; // liste des images de f qui ne sont pas des extrema
local NoeudsNonExtrema_g; // liste des images de g qui ne sont pas des extrema
local sTkzTabLine; // ligne des signes de f' ou g'
local sTkzTabVar; // ligne des variations de f ou g
local sTkzTabIma; // lignes des images de f ou g
local k,n,j;
local id_fonction_f, nom_variable_f, nom_fonction_f, nom_derivee_f;
local id_fonction_g, nom_variable_g, nom_fonction_g, nom_derivee_g;

initCas();
id_fonction_f:=identifier(f);
f:=id_fonction_f[0];
nom_variable_f:=id_fonction_f[1][1];
nom_fonction_f:=id_fonction_f[2][1];
nom_derivee_f:=id_fonction_f[3][1];
id_fonction_g:=identifier(g);
g:=id_fonction_g[0];
nom_variable_g:=id_fonction_g[1][1];
nom_fonction_g:=id_fonction_g[2][1];
nom_derivee_g:=id_fonction_g[3][1];
fp:=function_diff(f);
gp:=function_diff(g);
IE:=sort(IE);
VI_f:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI_f);
VI_g:=trouveVI(IE,g(x));
ValeursX:=insereValeurs(ValeursX,VI_g);
Zeros_fp:=trouveZeros(IE,fp);
Zeros_fp:=sontDefinies(f,Zeros_fp);
ValeursX:=insereValeurs(ValeursX,Zeros_fp);
Zeros_gp:=trouveZeros(IE,gp);
Zeros_gp:=sontDefinies(g,Zeros_gp);
ValeursX:=insereValeurs(ValeursX,Zeros_gp);
ValeursX:=sort([op(set[op(ValeursX)])]);
ValeursX:=simplifier(ValeursX);
// construction de la structure du tableau
sTkzTab:=debutTableau(["$"+nom_variable_f+"$",
      "$"+nom_derivee_f+"("+nom_variable_f+")"+"$","$"+nom_fonction_f+"$",
      "$"+nom_fonction_g+"$","$"+nom_derivee_g+"("+nom_variable_g+")"+"$"],
      [1,1,2,2,1],ValeursX);
// construction du signe de f'
Signes_fp:=tabSignes(ValeursX,fp,f);
sTkzTabLine:=ligneSignesTVP(Signes_fp);
sTkzTab+=sTkzTabLine;
// construction des variations de f
Images_f:=calculeImages(ValeursX,f);
Variations_f:=calculePosition(ValeursX,VI_f,f,Images_f);
sTkzTabVar:=ligneVariations(Variations_f,Images_f);
sTkzTab+=sTkzTabVar;
// construction des images de f
NoeudsNonExtrema_f:=noeudsNonExtrema(Variations_f);
sTkzTabIma:=lignesImages(NoeudsNonExtrema_f,Images_f);
sTkzTab+=sTkzTabIma;
// construction des variations de g
Images_g:=calculeImages(ValeursX,g);
Variations_g:=calculePosition(ValeursX,VI_g,g,Images_g);
sTkzTabVar:=ligneVariations(Variations_g,Images_g);
sTkzTab+=sTkzTabVar;
// construction des images de g
NoeudsNonExtrema_g:=noeudsNonExtrema(Variations_g);
sTkzTabIma:=lignesImages(NoeudsNonExtrema_g,Images_g);
sTkzTab+=sTkzTabIma;
// construction du signe de g'
Signes_gp:=tabSignes(ValeursX,gp,g);
sTkzTabLine:=ligneSignesTVP(Signes_gp);
sTkzTab+=sTkzTabLine;
sTkzTab+="\\end{tikzpicture}\n";
return(sTkzTab);
}:;

purge(x);
]]
