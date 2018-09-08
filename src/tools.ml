let process_file process filename output =
    let ch = open_in filename in
    try while true do process (input_line ch) !output done
    with End_of_file -> close_in ch
;;

let print_file s output =
  begin
    !output := s
  end
;;

let get_result p =
  !(!(!p))
;;

let read_text_file filename =
  let output_file = ref (ref ( ref "")) in
  let read_func out =
    process_file print_file filename output_file
  in
  read_func output_file; get_result(output_file) 
;;
