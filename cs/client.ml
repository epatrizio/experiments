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
              output_string oc ((Cstruct.to_string (sign_msg priv_key log))^"\n");
              flush oc;
              let r = input_line ic in
                Printf.printf "Response : %s\n\n" r;
                if r = "END" then (Unix.shutdown_connection ic; raise Exit)
          done
  with
  | CryptoError msg -> Printf.printf "%s\n" msg; flush stdout; exit 0
  | Exit -> exit 0
  | exn -> Unix.shutdown_connection ic ; raise exn

let () =
  print_endline "Client start ...";
  client client_login
