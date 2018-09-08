let implode_reverse l_string =
  let rec imp_func l s =
    match l with
      | [] -> s
      | [e] -> e^"\n"^s
      | e::rl -> imp_func rl (e^"\n"^s)
  in imp_func l_string ""
;;


let read_file_lines filename =
  let rec read_func channel buffer =
    match try (input_line channel) with End_of_file -> "@@@@@@@END@@@@@@@" with
      | "@@@@@@@END@@@@@@@" -> buffer
      | e -> read_func channel (e::buffer)
  in implode_reverse (read_func (open_in filename) [])
;;

