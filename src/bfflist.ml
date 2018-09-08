let rec init_list length value =
  match length with
      n when n < 0 -> failwith "BffList.init_list"
    | 0 -> []
    | n -> value::(init_list (n-1) value)
;;

let rec init_big_list length value =
  match length with
      0 -> []
    | n when (n mod 10000) < 10000 -> init_list n value
    | n -> (init_list 10000 value) @ (init_big_list (length - 10000) value)
;;

let rec length l =
  match l with
      [] -> 0
    | _::l -> 1 + length l
;;

let reverse l =
  let rec rev l buffer =
    match l with
	[] -> buffer
      | e::l -> rev l (e::buffer)
  in rev l []
;;

let nth l n =
  if n < 0 then invalid_arg "BffList.nth" else
    let rec nth_rec l n =
      match l with
	  [] -> failwith "BffList.nth"
	| e::_ when n == 0 -> e
	| _::l -> nth_rec l (n-1)
    in nth_rec l n
;;

let rec in_list l x =
  match l with
      [] -> false
    | e::_ when e == x -> true
    | _::l -> in_list l x
;;

let index_of l x =
  let rec index_rec l x i =
      match l with
      [] -> failwith "List.index_of"
    | e::_ when e == x -> i
    | _::l -> index_rec l x (i+1)
  in index_rec l x 0
;;
    
       
let implode l join =
  let rec imp_rec l buffer =
    match l with
	[] -> buffer
      | e::l -> imp_rec l (buffer^join^e)
  in match l with
      [] -> ""
    | e::l -> imp_rec l e
;;

let explode s boundary =
  let rec exp_rec n buffer out_list =
    match n with
      | n when n < 0 -> out_list
      | 0 -> ((Char.escaped (s.[n]))^buffer)::out_list
      | n when s.[n] == boundary -> exp_rec (n-1) "" (buffer::out_list)
      | n -> exp_rec (n-1) ((Char.escaped s.[n])^buffer) out_list
  in exp_rec (String.length s - 1) "" []
;;
