(*
#use "tools.ml";;
#use "lexer.ml";;
#use "parser.ml";;
*)

let usage_msg = "Brainfuck Compiler \n\n Usage: \n\n";;

let verbose = ref false;;
let input_file_path = ref "brainfuck.b";;
let output_file_path = ref "./brainfuck.exe";;
 
let set_input_file input_file = input_file_path := input_file;; 
let set_output_file output_file = output_file_path := output_file;;

let arg_speclist = [("-v", Arg.Set verbose, "Enables verbose mode");
  ("-i", Arg.String (set_input_file), "Brainfuck file path");
  ("-o", Arg.String (set_output_file), "Output file name")
];;

let main () =
  begin
     print_endline("Brainfuck Compiler\n\nInit ...\n");
     Arg.parse arg_speclist print_endline usage_msg;
     print_endline ("Verbose mode: " ^ string_of_bool !verbose);
     print_endline ("Input file path: " ^ !input_file_path);
     print_endline ("Output file path: " ^ !output_file_path);

     
   end
;;

let () = main ();;



