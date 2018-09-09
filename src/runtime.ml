let brainfuck = "123++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.";;

let rec init_list length value =
  match length with
      n when n < 0 -> failwith "Runtime.init_list"
    | 0 -> []
    | n -> value::(init_list (n-1) value)
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

let modify_mem l n x =
  let rec modify l n =
    match l with
	[] when n > 0 -> failwith "Runtime.modify_list"
      | [] -> []
      | e::l when n == 0 -> x::l
      | e::l -> e::(modify l (n-1))
  in match n with
      n when n < 0 -> invalid_arg "Runtime.modify_list"
    | n -> modify l n
;;

let dump_mem mem =
  let rec dump m n =
    match m with
      [] -> ()
      | e::l -> print_endline ((string_of_int n)^" : "^(string_of_int e)); dump l (n+1)
in dump mem 0
;;

let get_mem_length b =
  let rec get n len =
    match n with
	n when n >= (String.length b) -> len
      | n ->
	match b.[n] with
	  | c when c >= '0' && c <= '9' -> get (n+1) ((len * 10) + ((int_of_char c) - 48))
	  | _ -> len
  in let r = get 0 0 in
     match r with
	 r when r <= 10 -> 1000
       | r -> r
;;

let pile_unpile pile =
  match pile with
      [] -> failwith "Runtime.unpile"
    | [e] -> e, []
    | e::l ->  e,l
;;

let search_end_loop b n =
  let rec search n =
    match n with
	n when n >= String.length b -> failwith "Runtime.search_end_loop"
      | n ->
	match b.[n] with
	    c when c == ']' -> n
	  | _ -> search (n+1)
  in search n
;;

let normalize_value v =
  match v with
      v when v < 0 -> 256 + v
    | v when v >= 256 -> v mod 256
    | v -> v
;;
      
let loop_pile = [];;
let func_pile = [];;

let len_memory = get_mem_length brainfuck;;
let memory = init_list len_memory 0;;
let pointer = 0;;

let current_char_id = 0;;
let len_brainfuck = String.length brainfuck;;

let rec run current_char_id memory pointer loop_pile func_pile =
  match current_char_id with
      n when n < 0 -> failwith "Runtime.run"
    | n when n == len_brainfuck -> ()
    | n ->
	let compute c =
	  match c with
	    | '+' ->
	      begin
		let memory = modify_mem memory pointer (normalize_value((nth memory pointer) + 1)) in
		run (n+1) memory pointer loop_pile func_pile;
	      end
       
	    | '-' ->
	      begin
		let memory = modify_mem memory pointer (normalize_value((nth memory pointer) - 1)) in
		run (n+1) memory pointer loop_pile func_pile;
	      end
		
	    | '<' -> run (n+1) memory (pointer-1) loop_pile func_pile
	    | '>' -> run (n+1) memory (pointer+1) loop_pile func_pile
	    | '[' ->
	      begin
		let v = nth memory pointer in
		let skip = v == 0 in
		if skip then run ((search_end_loop b n)+1) memory pointer loop_pile func_pile then run (n+1) memory pointer (n::loop_pile) func_pile
	      end
		
	    | ']' ->
	      begin
		let (head_loop, loop_pile) = pile_unpile loop_pile in
		let loop = (nth memory pointer) != 0 in
		(if loop then run (head_loop+1) memory pointer (head_loop::loop_pile) func_pile else run (n+1) memory pointer loop_pile func_pile)
	      end
		
	    | '.' -> print_char (char_of_int (nth memory pointer)); run (n+1) memory pointer loop_pile func_pile 
	    | ',' ->
	      begin
		let memory = modify_mem memory pointer (read_int()) in
		run (n+1) memory pointer loop_pile func_pile
	      end
		
	    | ')' -> run (n+1) memory pointer loop_pile func_pile
	    | '(' -> run (n+1) memory pointer loop_pile func_pile
	    | 'd' -> dump_mem memory; run (n+1) memory pointer loop_pile func_pile
	    | _ -> run (n+1) memory pointer loop_pile  func_pile
	in compute (brainfuck.[n])
;;

let _ = run 0 memory pointer loop_pile func_pile;;
