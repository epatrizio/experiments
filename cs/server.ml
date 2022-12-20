open Mirage_crypto_ec

open Crypto
open Utils

let server service_fun =
  let port = 1400 in
  let localhost = get_localhost () in
    Unix.establish_server service_fun (Unix.ADDR_INET(localhost, port))

let check_service ic oc =
  try
    let p_key = get_public_bkey keys.public_key in
      match p_key with
      | None -> raise (CryptoError "public key error")
      | Some pub_key ->
          while true do
            let in_sign = Cstruct.of_string (input_line ic) in
            let check = verify_msg pub_key in_sign user_login in
              output_string oc (if check then "sign authentication OK :)\n" else "sign authentication KO :(\n");
              flush oc;
          done
  with
  | CryptoError msg -> Printf.printf "%s\n" msg; flush stdout; exit 0
  | _ -> Printf.printf "End of text\n"; flush stdout; exit 0

let go_check_service () = 
  Unix.handle_unix_error server check_service

let () =
  print_endline "Server start ...";
  go_check_service ()
