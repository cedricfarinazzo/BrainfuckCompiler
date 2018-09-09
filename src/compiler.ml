let download_runtime_code () =
  Sys.command "wget https://raw.githubusercontent.com/cedricfarinazzo/BrainfuckCompiler/master/src/runtime.ml"
;;

let gen_code brainfuck =
  "let brainfuck = \""^brainfuck^"\";;\nRuntime.main brainfuck;;"

let write_gen_code filename code =
  Tools.write_file (filename^".ml") code
;;

let build_code filename base =
  let c1 = Sys.command ("ocamlc -c -dtypes runtime.ml") in
  let c2 = Sys.command ("ocamlc -c -dtypes "^base^".ml") in
  let c3 = Sys.command ("ocamlc -o "^filename^" runtime.cmo "^base^".cmo")
  in (c1*1000000) + (c2*1000) + (c3)
;;

let get_base_filename filename =
  let a = Bfflist.explode filename '.' in
  let b = Bfflist.reverse a in
  match b with
      [] -> ""
    | _::c -> let d = Bfflist.reverse c in
	      Bfflist.implode d "." 
;;

let main out_filename brainfuck =
  let code = download_runtime_code () in
  print_endline ("Status code : "^(string_of_int code));
  let base = get_base_filename out_filename in
  let code = gen_code brainfuck in
  write_gen_code base code;
  build_code out_filename base
;;

