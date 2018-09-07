let rec string_to_list s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

let valid_word w loop_pile func_pile =
  match w with
    | '>' | '<' | '+' | '-' | ',' | '.' -> true, loop_pile, func_pile
    | '[' -> true, loop_pile+1, func_pile
    | ']' -> true, loop_pile-1, func_pile
    | '(' -> true, loop_pile, func_pile+1
    | ')' -> true, loop_pile, func_pile-1
    | _ -> true, loop_pile, func_pile
;;      

let lex s =
  let s_list = string_to_list s in
  let rec func_lex s_list loop_pile func_pile =
     match s_list with
       | [] -> loop_pile == 0 && func_pile == 0
       | elm::sl -> let (valid, loop_pile, func_pile) = valid_word elm loop_pile func_pile in valid && func_lex sl loop_pile func_pile
  in func_lex s_list 0 0
;;

(*
 let brainfuck = ">>[-]()<<[->>+<<]";;
lex brainfuck;;
*)
