(* This file uses some advanced parsing techniques
   to parse juxtaposed applications [e1 e2 e3] the
	 same way as OCaml does. *)

%{
open Ast

(** [make_apply e [e1; e2; ...]] makes the application  
    [e e1 e2 ...]).  Requires: the list argument is non-empty. *)
let rec make_apply e = function
  | [] -> failwith "precondition violated"
  | [e'] -> App (e, e')
  | h :: ((_ :: _) as t) -> make_apply (App (e, h)) t
%}

%token <string> ID
%token FUN
%token ARROW
%token LPAREN
%token RPAREN
%token <int> INT
%token TRUE
%token FALSE
%token LEQ
%token TIMES  
%token PLUS
%token LET
%token EQUALS
%token IN
%token IF
%token THEN
%token ELSE
%token COMMA
%token FST
%token SND
%token LEFT
%token RIGHT
%token MATCH
%token WITH
%token PIPE
%token EOF

%nonassoc IN
%nonassoc ELSE
%left LEQ
%left PLUS
%left TIMES  

%start <Ast.expr> prog

%%

prog:
	| e = expr; EOF { e }
	;
	
expr:
	| e = simpl_expr { e }
	| e = simpl_expr; es = simpl_expr+ { make_apply e es }
	| FUN; x = ID; ARROW; e = expr { Fun (x, e) }
	| e1 = expr; LEQ; e2 = expr { Binop (Leq, e1, e2) }
	| e1 = expr; TIMES; e2 = expr { Binop (Mult, e1, e2) } 
	| e1 = expr; PLUS; e2 = expr { Binop (Add, e1, e2) } 
	| IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr { If (e1, e2, e3) }
    | LPAREN; e1 = expr; COMMA; e2 = expr; RPAREN { Pair (e1, e2) }
    | FST; e = expr; { Fst e } | SND; e = expr; { Snd e }
    | LEFT; e = expr; { Left e } | RIGHT; e = expr; { Right e }
    | MATCH; e = expr; 
      WITH; LEFT; x1 = ID; ARROW; e1 = expr
      PIPE; RIGHT; x2 = ID; ARROW; e2 = expr
    | MATCH; e = expr; 
      WITH; RIGHT; x2 = ID; ARROW; e2 = expr
      PIPE; LEFT; x1 = ID; ARROW; e1 = expr
      { Match (e, x1, e1, x2, e2) }
	| LET; x = ID; EQUALS; e1 = expr; IN; e2 = expr { Let (x, e1, e2) }
	;

simpl_expr:
	| i = INT { Int i }
	| x = ID { Var x }
	| TRUE { Bool true }
	| FALSE { Bool false }
	| LPAREN; e=expr; RPAREN {e} 
    ;
