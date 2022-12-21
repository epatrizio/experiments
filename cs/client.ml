open Mirage_crypto_ec

open Crypto
open Utils

let client client_fun  =
  let port = 1400 in
  let localhost = get_localhost () in
  let sockaddr = Unix.ADDR_INET(localhost, port) in
  let ic, oc = Unix.open_connection sockaddr in
    client_fun ic oc;
    Unix.shutdown_connection ic

let client_login ic oc =
  try
    let p_key = get_private_bkey keys.private_key in
      match p_key with
      | None -> raise (CryptoError "private key error")
      | Some priv_key ->
          while true do
            print_string "Login: ";
            flush stdout;
            let log = Cstruct.of_string (input_line stdin) in
              output_string oc ((Cstruct.to_string (sign_msg priv_key log))^"\n");  (* sign login with private key *)
              flush oc;
              let resp = input_line ic in
                Printf.printf "Response: %s\n\n" resp;
                if resp = "OK" then (print_endline "Authetication success!"; raise Exit)
          done
  with
  | CryptoError msg -> Unix.shutdown_connection ic; print_endline msg; flush stdout; exit 0
  | Exit -> Unix.shutdown_connection ic; print_endline "Client close!"; flush stdout; exit 0

let () =
  print_endline "Client start ...";
  client client_login
