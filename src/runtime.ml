let brainfuck = "{{ BRAIN**** }}"

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

let search_end_func b n =
  let rec search n =
    match n with
	n when n >= String.length b -> failwith "Runtime.search_end_fuck"
      | n ->
	match b.[n] with
	    c when c == ')' -> n
	  | _ -> search (n+1)
  in search n
;;

let rec get_func pointer func_pile =
  match func_pile with
      [] -> failwith "Runtime.get_func"
    | (p,d)::_ when pointer == p -> d
    | _::l -> get_func pointer l
;;

let normalize_value v =
  match v with
      v when v < 0 -> 256 + v
    | v when v >= 256 -> v mod 256
    | v -> v
;;

let normalize_pointer pointer len_memory =
  match pointer with
      pointer when pointer < 0 -> 0
    | pointer -> pointer mod len_memory
;;

let runbrainfuck brainfuck=
  let loop_pile = [] in
  let func_pile = [] in
  let len_memory = get_mem_length brainfuck in
  let memory = init_list len_memory 0 in
  let pointer = 0 in
  (* let current_char_id = 0 in *)
  let len_brainfuck = String.length brainfuck in
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
		
	    | '<' -> run (n+1) memory (normalize_pointer (pointer-1) len_memory) loop_pile func_pile
	    | '>' -> run (n+1) memory (normalize_pointer (pointer+1) len_memory) loop_pile func_pile
	    | '[' ->
	      begin
		let v = nth memory pointer in
		let skip = v == 0 in
		if skip then run ((search_end_loop brainfuck n)+1) memory pointer loop_pile func_pile else run (n+1) memory pointer (n::loop_pile) func_pile
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
		
	    | '(' ->
		let execute = ')' == brainfuck.[n+1] in
		if execute then
		  begin
		    let (head_func, _) = get_func pointer func_pile in
		    run (head_func + 1) memory pointer loop_pile func_pile;
		    run (n+2) memory pointer loop_pile func_pile
		  end
		else
		  begin
		    let end_func = search_end_func brainfuck n in
		    let func_pile = (pointer, (n, end_func))::func_pile in
		    run (end_func+1) memory pointer loop_pile func_pile
		  end
		    
	    | ')' -> ()
	    | 'd' -> dump_mem memory; run (n+1) memory pointer loop_pile func_pile
	    | _ -> run (n+1) memory pointer loop_pile  func_pile
	in compute (brainfuck.[n])
  in run 0 memory pointer loop_pile func_pile
;;


let main brainfuck =
  match brainfuck with
      brainfuck when brainfuck != "{{ BRAIN**** }}" -> runbrainfuck brainfuck
    | _ -> ()
;;

main brainfuck;;
