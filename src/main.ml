
(* ARG *)

let usage_msg = "Brainfuck Compiler \n\n Usage: \n\n";;

let verbose = ref false;;
let input_file_path = ref "brainfuck.b";;
let output_file_path = ref "";;
 
let set_input_file input_file = input_file_path := input_file;; 
let set_output_file output_file = output_file_path := output_file;;

let arg_speclist = [("-v", Arg.Set verbose, "Enables verbose mode");
  ("-i", Arg.String (set_input_file), "Brainfuck file path");
  ("-o", Arg.String (set_output_file), "Output file name")
];;

(* SYNTAX *)
exception SyntaxError of string;;
let syntax_checking_action_verbose ok =
  if ok  == true then print_endline ("OK") else raise (SyntaxError "Invalid brainfuck code ! Please check your code and try again.")
;;

let syntax_checking_action ok =
  if ok  == true then () else raise (SyntaxError "Invalid brainfuck code ! Please check your code and try again.")
;;


(* MAIN *)

let main () =
  begin
    Arg.parse arg_speclist print_endline usage_msg;
    if !verbose then
      begin
	print_endline ("Brainfuck Compiler\n\nInit ...\n");
	print_endline ("Verbose mode: " ^ string_of_bool !verbose);
	print_endline ("Input file path: " ^ !input_file_path);
	print_endline ("Output file path: " ^ !output_file_path);

	print_endline ("\n\nRead input file ...");
	let input_file_content = Tools.read_file_lines (!input_file_path) in
	begin
	  print_endline ("\nSyntax checking ...");
	  let syntaxOK = Lexer.lex input_file_content in
	  syntax_checking_action_verbose syntaxOK;
	  if (String.length !output_file_path) == 0 then
	    begin
	      print_endline ("\nRunning mode\n\n");
	      Runtime.main input_file_content
	    end
	  else
	    begin
	      print_endline ("\nBuilding mode\n\n");
	      let code = Compiler.main !output_file_path input_file_content
	      in print_endline ("Build code : "^(string_of_int code))
	    end
	end
      end
    else
      begin
	let input_file_content = Tools.read_file_lines (!input_file_path) in
	begin
	  let syntaxOK = Lexer.lex input_file_content in
	  syntax_checking_action syntaxOK;
	  if (String.length !output_file_path) == 0 then
	    begin
	      Runtime.main input_file_content
	    end
	  else
	    begin
	      let code = Compiler.main !output_file_path input_file_content
	      in
	      match code with
		  _ -> ()
	    end
	end
      end
   end
;;

let () = main ();;



