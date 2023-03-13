(** The type of binary operators. *)
type bop = 
  | Add
  | Mult
  | Leq

(** The type of the abstract syntax tree (AST). *)
type expr =
  | Var of string
  | App of expr * expr
  | Fun of string * expr
  | Int of int
  | Bool of bool  
  | Binop of bop * expr * expr
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  | Left of expr
  | Right of expr
  | Match of expr * string * expr * string * expr
  | Let of string * expr * expr
  | If of expr * expr * expr
