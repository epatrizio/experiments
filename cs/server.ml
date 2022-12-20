open Mirage_crypto_ec

open Crypto
open Utils

let server service_fun =
  let port = 1400 in
  let localhost = get_localhost () in
    Unix.establish_server service_fun (Unix.ADDR_INET(localhost, port))

let check_service ic oc =
  try
    while true do
      let in_sign = Cstruct.of_string (input_line ic) in
      let res = Ed25519.pub_of_cstruct (Cstruct.of_bytes keys.public_key) in
        match res with
        | Ok pub -> let check = verify_msg pub in_sign user_login in
                      output_string oc (if check then "OK :)\n" else "KO :(\n");
                      flush oc;
        | Error _ -> output_string oc "error"; flush oc
    done
  with _ -> Printf.printf "End of text\n" ; flush stdout ; exit 0

let go_check_service () = 
  Unix.handle_unix_error server check_service

let () =
  print_endline "Server start ...";
  go_check_service ()
